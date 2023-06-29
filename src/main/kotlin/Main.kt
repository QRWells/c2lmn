import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream

fun main() {
    val text = CharStreams.fromString("int add(int a, int b) { return 0; }")
    val lexer = CLexer(text)
    val tokenStream = CommonTokenStream(lexer)
    val parser = CParser(tokenStream)

    println(parser.program().children)
}