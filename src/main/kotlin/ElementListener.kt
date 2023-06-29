import java.util.*

class ElementListener() : CBaseListener() {
    private var root: Membrane = Membrane("root")

    override fun enterFunctionDefinition(ctx: CParser.FunctionDefinitionContext) {
        val declarator = ctx.declarator()
        val name = declarator.directDeclarator().directDeclarator().Identifier().text
        val rule = Rule(Optional.of(name))

        val parameters = declarator.directDeclarator().parameterTypeList().parameterList().parameterDeclaration()
        for (parameter in parameters) {
            val type = parameter.declarationSpecifiers().text
            var atomName = parameter.declarator().directDeclarator().Identifier().text
            val atom = Atom(atomName)
            atomName =
                atomName.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() }
            atom.value = Optional.of(getDefaultByType(type))
            rule.addHead(atom)
            rule.addGuard(UnaryExprNode(type, VariableExprNode(atomName.uppercase(Locale.getDefault()))))
        }

        val blocks = ctx.compoundStatement().blockItemList().blockItem()
        for (block in blocks) {
            if (block.declaration() != null) {
                val specifiers = block.declaration().declarationSpecifiers().declarationSpecifier()
                val type = specifiers[0].typeSpecifier().text
                if (specifiers.size > 1) {
                    val atomName = specifiers[1].text
                    val atom = Atom(atomName)
                    atom.value = Optional.of(getDefaultByType(type))
                    rule.addBody(atom)
                }
            }
        }

        root.addRule(rule)
    }

    override fun enterDeclaration(ctx: CParser.DeclarationContext) {
        val type = ctx.declarationSpecifiers().text
        val list = ctx.initDeclaratorList()
        if (list == null) {
            return
        }

        for (initDeclarator in list.initDeclarator()) {
            val declarator = initDeclarator.declarator().directDeclarator().Identifier().text
            val atom = Atom(declarator)
            if (initDeclarator.Assign() != null) {
                val value = initDeclarator.initializer().text
                atom.value = Optional.of(parseValueByType(type, value))
            }
            root.addAtom(atom)
        }
    }

    fun getRoot(): Membrane {
        return root
    }

    private fun getDefaultByType(type: String): Any {
        return when (type) {
            "int" -> 0
            "float" -> 0.0
            else -> ""
        }
    }

    private fun parseValueByType(type: String, value: String): Any {
        return when (type) {
            "int" -> value.toInt()
            "float" -> value.toDouble()
            else -> value
        }
    }
}