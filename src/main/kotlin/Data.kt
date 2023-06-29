import java.util.*

class Rule(private val name: Optional<String> = Optional.empty()) : Cloneable {
    fun generate(): String {
        val result = StringBuilder()
        if (name.isPresent) {
            result.append(name.get() + " @@ ")
        }
        for ((i, atom) in head.filterIsInstance<Atom>().withIndex()) {
            result.append("${atom.name}=${atom.name.uppercase(Locale.getDefault())}")
            if (i != head.size - 1) {
                result.append(", ")
            }
        }

        result.append(" :- ")

        if (guard.isNotEmpty()) {
            for ((i, expr) in guard.withIndex()) {
                result.append(expr.toString())
                if (i != guard.size - 1) {
                    result.append(", ")
                }
            }
            result.append(" | ")
        }

        if (body.isNotEmpty()) {
            for ((i, atom) in body.filterIsInstance<Atom>().withIndex()) {
                result.append(atom.name)
                if (i != body.size - 1) {
                    result.append(", ")
                }
            }
        }

        return result.toString()
    }

    fun addHead(element: Element) {
        head.add(element)
    }

    fun addBody(element: Element) {
        body.add(element)
    }

    fun addGuard(expr: ExprNode) {
        guard.add(expr)
    }

    private val head: MutableList<Element> = mutableListOf()
    private val guard: MutableList<ExprNode> = mutableListOf()
    private val body: MutableList<Element> = mutableListOf()

    override fun clone(): Any {
        val rule = Rule(name)
        rule.head.addAll(head)
        rule.guard.addAll(guard)
        rule.body.addAll(body)
        return rule
    }
}

abstract class ExprNode {

}

class VariableExprNode(private val name: String = "") : ExprNode() {
    override fun toString(): String {
        return name
    }
}

class BinaryExprNode(val op: String, val left: ExprNode, val right: ExprNode) : ExprNode() {
    override fun toString(): String {
        return "($left $op $right)"
    }
}

class UnaryExprNode(val op: String, val expr: ExprNode) : ExprNode() {
    override fun toString(): String {
        return "$op($expr)"
    }
}

abstract class Element(val name: String = "") {

}

class Atom(name: String = "") : Element(name) {
    var value: Optional<Any> = Optional.empty()

    override fun toString(): String {
        return "Atom(name='$name', value=$value, type: ${value::class.simpleName})"
    }

    fun generate(): String {
        val result = StringBuilder()
        if (value.isPresent) {
            result.append("$name = ${value.get()}")
        } else {
            result.append(name)
        }
        return result.toString()
    }
}

class Membrane(name: String = "") : Element(name) {
    private val body: MutableList<Element> = mutableListOf()
    private val rules: MutableList<Rule> = mutableListOf()

    override fun toString(): String {
        return "Membrane(name='$name', body=$body, rules=$rules)"
    }

    fun addRule(rule: Rule) {
        rules.add(rule)
    }

    fun addAtom(atom: Atom) {
        body.add(atom)
    }

    fun getAtoms(): List<Atom> {
        return body.filterIsInstance<Atom>()
    }

    fun generate(): String {
        val result = StringBuilder()
        for (atom in getAtoms()) {
            result.append(atom.generate() + ".\n")
        }
        for (rule in rules) {
            result.append(rule.generate() + ".\n")
        }
        return result.toString()
    }
}