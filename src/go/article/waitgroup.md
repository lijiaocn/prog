<!-- toc -->
# Go 并发与按值传递引发的血案

前段时间出去面试的时候，被一道题难住了，问下面这段代码的运行输出是什么：

```go
func wg1() {
    wg := sync.WaitGroup{}

    for i := 0; i < 10; i++ {
        go func(wg sync.WaitGroup) {
            wg.Add(1)
            println(i)
            wg.Done()
        }(wg)
    }
    wg.Wait()
}
```

当时没有搞清楚 sync.WaitGroup 的特性，结果很尴尬。面试官给的答案是没有任何输出，原因是 wg 按值传递。事实上，情况不是这么简单，正确的答案是「不确定」，可能没有输出，可能打印少于 10 个数字，可能打印了几个重复的数字。

这段代码的问题很大，涉及按值传递、并发，以及变量作用域等方面的内容，改了几次才改出正确的代码。

## wg2()：不仅仅是传值的问题

如果只是按值传递的问题，即 wg 被复制了 10 份导致 wg.Wait() 没有等待，那么换用指针应该能解决问题：

```go
func wg2() {
    wg := sync.WaitGroup{}

    for i := 0; i < 10; i++ {
        go func(wg *sync.WaitGroup) {
            wg.Add(1)
            println(i)
            wg.Done()
        }(&wg)
    }
    wg.Wait()
}
```

结论是不行！运行结果不稳定，数字有重复，而且有时还会 panic：

```sh
$ ./waitgroup
10
10
10
10
10

$ ./waitgroup
8
10
10
...

panic: sync: WaitGroup is reused before previous Wait has returned
```

## wg3()：简化场景直接使用 wg

先简化场景，把按值传递的问题排除，直接使用 wg：

```go
func wg3() {
    wg := sync.WaitGroup{}

    for i := 0; i < 10; i++ {
        go func() {
            wg.Add(1)
            println(i)
            wg.Done()
        }()
    }
    wg.Wait()
}
```

**大多数情况下** 会打印 10 个数字，但是数字有重复：

```go
$ ./waitgroup
4
4
4
10
10
10
10
10
10
10
```

**这段代码在 goroutine 方面还是有问题的，wg5() 中说明**

## wg4()：i 通过参数传递，消除重复

wg3() 有两个问题，第一输出的数字重复，第二偶尔输出的数字不足 10 个，先解决数字重复的问题。

数字重复是因为 goroutine 中直接使用了变量 i，打印的是 goroutine 执行时的 i 值，而不是创建 goroutine 时的 i 值。

将 i 改为参数传递：

```go
func wg4() {
    wg := sync.WaitGroup{}

    for i := 0; i < 10; i++ {
        go func(i int) {
            wg.Add(1)
            println(i)
            wg.Done()
        }(i)
    }
    wg.Wait()
}
```

这时候，输出结果中没有重复的数字：

```sh
$ ./waitgroup
1
6
5
7
0
4
2
8
3
9
```

第二个问题没有解决，有时候输出的数字不足 10 个，例如：

```sh
$ ./waitgroup
0
2
1
$ ./waitgroup
1%
```

## wg5()：将 wg 的操作移出 goroutine

wg3() 和 wg4() 中的主函数有可能在 goroutine 之前退出，导致输出的数字不足 10 个。为什么会这样，wg.wait() 无效吗？

问题在于 wg.Add() 的执行时机，仔细看 wg3() 和 wg4() 中的 wg.Add()，它是在 goroutine 中执行的。

因为 goroutine 是并发的，wg.Add() 还没执行, 主函数可能就执行到了 wg.wait() ，从而直接退出。

需要将 wg.Add() 移出 goroutine，确保 wg.Wait() 有效，注意 wg.Done() 不能移出，否则主函数又会先于 goroutine 退出：

```go
func wg5() {
    wg := sync.WaitGroup{}

    for i := 0; i < 10; i++ {
        wg.Add(1)
        go func(i int) {
            println(i)
            wg.Done()
        }(i)
    }
    wg.Wait()
}
```

这时候稳定输出 10 个不重复的数字，数字不是递增排列，因为 goroutine 并发执行，顺序不固定：

```go
1
0
4
3
5
6
9
7
8
2
```

## wg6()：重新用指针传递

回顾 wg2()，因为不确定指针的效用，wg3()~wg5() 中没有使用指针，在简化的场景下解决了并发和数字重复的问题。

现在验证一下使用指针是否可行：

```go
func wg6() {
    wg := sync.WaitGroup{}

    for i := 0; i < 10; i++ {
        wg.Add(1)
        go func(i int, wg *sync.WaitGroup) {
            println(i)
            wg.Done()
        }(i, &wg)
    }
    wg.Wait()
}
```

结论是可以，而且这种情况下必须使用指针，如果不用指针是有问题的。

如果不用指针，goroutine 中的 wg.Done() 是无效的，因为 goroutine 中的 wg 是一个副本，结果会是这样：

```sh
1
0
5
2
9
6
4
8
7
3
fatal error: all goroutines are asleep - deadlock!

goroutine 1 [semacquire]:
sync.runtime_Semacquire(0xc000068008)
	/Users/lijiao/Work/Bin/go-1.13/go/src/runtime/sema.go:56 +0x42
sync.(*WaitGroup).Wait(0xc000068000)
	/Users/lijiao/Work/Bin/go-1.13/go/src/sync/waitgroup.go:130 +0x64
main.wg7()
	/Users/lijiao/Work/go-code-example/waitgroup/waitgroup.go:97 +0xbb
main.main()
	/Users/lijiao/Work/go-code-example/waitgroup/waitgroup.go:107 +0x20

Process finished with exit code 2
```

## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"
