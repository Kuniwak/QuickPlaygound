import Quick
import Nimble
import MirrorDiffKit


class TableOfContentsSpec1: QuickSpec {
    override func spec() {
        describe("ExampleEquatable") {
            context("when not using MirrorDiffKit") {
                it("print messy output") {
                    let a = ExampleEquatable(
                        key1: "i'm not changed",
                        key2: "i'm deleted",
                        key3: "i'm not changed",
                        key4: "i'm not changed",
                        key5: "i'm not changed",
                        key6: "i'm not changed",
                        key7: "i'm not changed",
                        key8: "i'm not changed",
                        key9: "i'm not changed"
                    )
                    let b = ExampleEquatable(
                        key1: "i'm not changed",
                        key2: "i'm inserted",
                        key3: "i'm not changed",
                        key4: "i'm not changed",
                        key5: "i'm not changed",
                        key6: "i'm not changed",
                        key7: "i'm not changed",
                        key8: "i'm not changed",
                        key9: "i'm not changed"
                    )
                    expect(a).to(equal(b))
                }
            }

            context("when using MirrorDiffKit") {
                it("print readable output") {
                    let a = ExampleEquatable(
                        key1: "i'm not changed",
                        key2: "i'm deleted",
                        key3: "i'm not changed",
                        key4: "i'm not changed",
                        key5: "i'm not changed",
                        key6: "i'm not changed",
                        key7: "i'm not changed",
                        key8: "i'm not changed",
                        key9: "i'm not changed"
                    )
                    let b = ExampleEquatable(
                        key1: "i'm not changed",
                        key2: "i'm inserted",
                        key3: "i'm not changed",
                        key4: "i'm not changed",
                        key5: "i'm not changed",
                        key6: "i'm not changed",
                        key7: "i'm not changed",
                        key8: "i'm not changed",
                        key9: "i'm not changed"
                    )
                    expect(a).to(equal(b), description: diff(between: b, and: a))
                }
            }
        }
    }


    struct ExampleEquatable: Equatable {
        let key1: String
        let key2: String
        let key3: String
        let key4: String
        let key5: String
        let key6: String
        let key7: String
        let key8: String
        let key9: String

        static func ==(lhs: ExampleEquatable, rhs: ExampleEquatable) -> Bool {
            return lhs.key1 == rhs.key1
                && lhs.key2 == rhs.key2
        }
    }
}
