import Quick
import Nimble
import MirrorDiffKit


class TableOfContentsSpec3: QuickSpec {
    override func spec() {
        describe("ExampleEquatable") {
            context("when not using MirrorDiffKit") {
                it("print messy output") {
                    let a = CGSize(
                        width: 1,
                        height: 1
                    )
                    let b = CGSize(
                        width: 1,
                        height: 2
                    )
                    expect(a).to(equal(b))
                }
            }

            context("when using MirrorDiffKit") {
                it("print readable output") {
                    let a = CGSize(
                        width: 1,
                        height: 1
                    )
                    let b = CGSize(
                        width: 1,
                        height: 2
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
}
