import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream
import org.antlr.v4.runtime.tree.ParseTreeWalker

fun main() {
    val text = CharStreams.fromString("""
        int a = 10;
        float b = 20, c;
        void add(int a, int b){
            int c;
        }
    """.trimMargin()
    )
    val lexer = CLexer(text)
    val tokenStream = CommonTokenStream(lexer)
    val parser = CParser(tokenStream)
    val tree = parser.compilationUnit()

    val walker = ParseTreeWalker()
    val listener = ElementListener()

    walker.walk(listener, tree)

    println(listener.getRoot().generate())
}

