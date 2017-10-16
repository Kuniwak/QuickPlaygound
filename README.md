Suggestion: MirrorDiffKit integration
=====================================

I am a developer of a developer of [MirrorDiffKit](https://github.com/Kuniwak/MirrorDiffKit) that is a structual diff library.
I think MirrorDiffKit is useful for Nimble users on some conditions.

So, can Nimble use MirrorDiffKit internally?
How do you feel about it?



# Motivation

The output of verifying structs or classes that have many stored properties with Nimble is hard to read:

```
expected to equal <ExampleEquatable(key1: "i\'m not changed", key2: "i\'m inserted", key3: "i\'m not changed", key4: "i\'m not changed", key5: "i\'m not changed", key6: "i\'m not changed", key7: "i\'m not changed", key8: "i\'m not changed", key9: "i\'m not changed")>, got <ExampleEquatable(key1: "i\'m not changed", key2: "i\'m deleted", key3: "i\'m not changed", key4: "i\'m not changed", key5: "i\'m not changed", key6: "i\'m not changed", key7: "i\'m not changed", key8: "i\'m not changed", key9: "i\'m not changed")>
```

In this case, MirrorDiffKit is useful.
MirrorDiffKit is a diff library that can output stored property differences between two structs or classes or enums.
For example, the following string is an output of MirrorDiffKit when comparing two structs:

```
  struct ExampleEquatable {
      key1: "i'm not changed"
    - key2: "i'm inserted"
    + key2: "i'm deleted"
  }
```

It can make readable output when comparing two structs or classes or enums that have many properties:

```
expected to equal <ExampleEquatable(key1: "i\'m not changed", key2: "i\'m inserted", key3: "i\'m not changed", key4: "i\'m not changed", key5: "i\'m not changed", key6: "i\'m not changed", key7: "i\'m not changed", key8: "i\'m not changed", key9: "i\'m not changed")>, got <ExampleEquatable(key1: "i\'m not changed", key2: "i\'m deleted", key3: "i\'m not changed", key4: "i\'m not changed", key5: "i\'m not changed", key6: "i\'m not changed", key7: "i\'m not changed", key8: "i\'m not changed", key9: "i\'m not changed")>
```

It becomes the following string:

```
  struct ExampleEquatable {
      key1: "i'm not changed"
    - key2: "i'm inserted"
    + key2: "i'm deleted"
      key3: "i'm not changed"
      key4: "i'm not changed"
      key5: "i'm not changed"
      key6: "i'm not changed"
      key7: "i'm not changed"
      key8: "i'm not changed"
      key9: "i'm not changed"
  }
```

And also, it can make readable output when comparing two sequences that have different order:

```
expected to equal <[i'm not changed, i'm not changed, i'm not changed, i'm not changed, i'm not changed, i'm inserted, i'm not changed]>, got <[i'm not changed, i'm deleted, i'm not changed, i'm not changed, i'm not changed, i'm not changed, i'm not changed]>
```

It becomes the following string:

```
  [
      "i'm not changed"
    + "i'm deleted"
      "i'm not changed"
      "i'm not changed"
      "i'm not changed"
      "i'm not changed"
    - "i'm inserted"
      "i'm not changed"
  ]
```

As seen above, MirrorDiffKit can help Nimble.



# Advantage and Disadvantage

- Advantage: 
	- Readable output for large objects
	- Readable output for order changes

- Disadvantage:
    - Problem about CoreGraphics Objects
	
	    Currently MirrorDiffKit is not familiar with CoreGraphics Objects.
	    For example, MirrorDiffKit returns the following broken output when comparing 2 CGSize:
	    
	    ```
        struct CGSize { height: generic Double {}, width: generic Double {} }
        ```

	- Output via xcpretty can be broken
	
	    I note the example output at end of the description.


## Example code
```swift
import Quick
import Nimble
import MirrorDiffKit


class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("Comparison for ExampleEquatable") {
            context("when not using MirrorDiffKit") {
                it("print messy output") {
                    let a = ExampleEquatable(
                        key1: "i'm not changed",
                        key2: "i'm deleted"
                    )
                    let b = ExampleEquatable(
                        key1: "i'm not changed",
                        key2: "i'm inserted"
                    )
                    expect(a).to(equal(b))
                }
            }

            context("when using MirrorDiffKit") {
                it("print readable output") {
                    let a = ExampleEquatable(
                        key1: "i'm not changed",
                        key2: "i'm deleted"
                    )
                    let b = ExampleEquatable(
                        key1: "i'm not changed",
                        key2: "i'm inserted"
                    )
                    expect(a).to(equal(b), description: diff(between: b, and: a))
                }
            }
        }
    }


    struct ExampleEquatable: Equatable {
        let key1: String
        let key2: String

        static func ==(lhs: ExampleEquatable, rhs: ExampleEquatable) -> Bool {
            return lhs.key1 == rhs.key1
                && lhs.key2 == rhs.key2
        }
    }
```


## Example output
### `xcodebuild test` output

```console
$ xcodebuild test -scheme QuickPlaygroundTests -destination 'platform=iOS Simulator,name=iPhone X,OS=latest'
Test Suite 'All tests' started at 2017-10-16 22:35:19.748
Test Suite 'QuickPlaygroundTests.xctest' started at 2017-10-16 22:35:19.749
Test Suite 'TableOfContentsSpec' started at 2017-10-16 22:35:19.751
Test Case '-[QuickPlaygroundTests.TableOfContentsSpec ExampleEquatable__when_not_using_MirrorDiffKit__print_messy_output]' started.
/Users/Kuniwak/Development/QuickPlayground/QuickPlaygroundTests/QuickPlaygroundTests.swift:19: error: -[QuickPlaygroundTests.TableOfContentsSpec ExampleEquatable__when_not_using_MirrorDiffKit__print_messy_output] : expected to equal <ExampleEquatable(key1: "i\'m notchanged", key2: "i\'m inserted")>, got <ExampleEquatable(key1: "i\'m not changed", key2: "i\'m deleted")>

Test Case '-[QuickPlaygroundTests.TableOfContentsSpec ExampleEquatable__when_not_using_MirrorDiffKit__print_messy_output]' failed (0.013 seconds).
Test Case '-[QuickPlaygroundTests.TableOfContentsSpec ExampleEquatable__when_using_MirrorDiffKit__print_readable_output]' started.
/Users/Kuniwak/Development/QuickPlayground/QuickPlaygroundTests/QuickPlaygroundTests.swift:33: error: -[QuickPlaygroundTests.TableOfContentsSpec ExampleEquatable__when_using_MirrorDiffKit__print_readable_output] :
  struct ExampleEquatable {
      key1: "i'm not changed"
    - key2: "i'm inserted"
    + key2: "i'm deleted"
  }

expected to equal <ExampleEquatable(key1: "i\'m not changed", key2: "i\'m inserted")>, got <ExampleEquatable(key1: "i\'m not changed", key2: "i\'m deleted")>
```



### `xcpretty` output

```console
All tests
Test Suite QuickPlaygroundTests.xctest started
TableOfContentsSpec
    ✗ ExampleEquatable__when_not_using_MirrorDiffKit__print_messy_output, expected to equal <ExampleEquatable(key1: "i\'m not changed", key2: "i\'m inserted")>, got <ExampleEquatable(key1: "i\'m not changed", key2: "i\'m deleted")>
    ✗ ExampleEquatable__when_using_MirrorDiffKit__print_readable_output,


QuickPlaygroundTests.TableOfContentsSpec
  ExampleEquatable__when_not_using_MirrorDiffKit__print_messy_output, expected to equal <ExampleEquatable(key1: "i\'m not changed", key2: "i\'m inserted")>, got <ExampleEquatable(key1: "i\'m not changed", key2: "i\'m deleted")>
  /Users/Kuniwak/Development/QuickPlayground/QuickPlaygroundTests/QuickPlaygroundTests.swift:19
  '''
                    )
                    expect(a).to(equal(b))
                }
  '''

  ExampleEquatable__when_using_MirrorDiffKit__print_readable_output,
  /Users/Kuniwak/Development/QuickPlayground/QuickPlaygroundTests/QuickPlaygroundTests.swift:33
  '''
                    )
                    expect(a).to(equal(b), description: diff(between: b, and: a))
                }
  '''


         Executed 2 tests, with 2 failures (0 unexpected) in 0.013 (0.015) seconds
```
