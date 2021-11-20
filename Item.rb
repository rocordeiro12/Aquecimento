class StudyItem
    def initialize(item)
        @titulo = item[:titulo]
        @categoria = Category.new(item[:categoria])
        @descricao = item[:descricao]
        @statusDiario = item[:statusDiario]
    end

    def titulo
        @titulo
    end

    def categoria
        @categoria.nome
    end

    def descricao
        @descricao
    end

    def statusDiario
        @statusDiario
    end
end