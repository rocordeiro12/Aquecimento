require_relative "study_item.rb"
require_relative "category.rb"

require 'sqlite3'

class StudyDiary
    def cadastraItem(titulo, categoria, descricao, statusDiario)
        item = StudyItem.new({titulo: titulo, categoria: categoria, descricao: descricao, statusDiario: statusDiario})

        db = SQLite3::Database.open "db/database.db"
        db.execute "INSERT INTO Diario (TITULO, CATEGORIA, DESCRICAO, STATUSDIARIO) VALUES ( '#{item.titulo}', '#{item.categoria}', '#{item.descricao}', '#{item.statusDiario}');"
        db.close()
        
        puts "\nItem cadastrado com sucesso!"

    end

    def menu()
        puts "\n[1] Cadastrar um item para estudar"
        puts "[2] Ver todos os itens cadastrados"
        puts "[3] Buscar um item de estudo"
        puts "[4] Sair"
        puts "[5] Deletar item cadastrado"
        puts "[6] Listar itens concluídos"
        puts "[7] Finalizar item de estudo"
    
        print "\nEscolha uma opção: "
        opcao = gets.chomp().to_i

        while true
            if opcao == 1
                print "Digite o título do item: "
                tituloItem = gets.chomp()
                print "Digite a categoria do item: "
                categoriaItem = gets.chomp()
                print "Insira uma descrição para o item: "
                descricaoItem = gets.chomp()
                print "Status do item: "
                statusDiarioItem = gets.chomp()

                cadastraItem(tituloItem, categoriaItem, descricaoItem, statusDiarioItem)
                menu()
            elsif opcao == 2
                db = SQLite3::Database.open "db/database.db"
                db.results_as_hash = true
                itens = db.execute "SELECT ID, TITULO, CATEGORIA, DESCRICAO, STATUSDIARIO FROM Diario"
                db.close
            
                itens.map {|item|
                    puts "Id: #{item['ID']} - Título: #{item['TITULO']}, Categoria: #{item['CATEGORIA']}, Descrição: #{item['DESCRICAO']}, Status: #{item['STATUSDIARIO']}"
                }

                menu()
            elsif opcao == 3
                print "Deseja listar itens por categoria? (S/N) "
                buscarPorCategoria = gets.chomp().downcase

                while buscarPorCategoria != "n" && buscarPorCategoria != "s"
                    puts "Resposta inválida, utilizar S ou N"

                    print "Deseja buscar por categoria? (S/N) "
                    buscarPorCategoria = gets.chomp().downcase
                end

                print "Digite uma palavra contida no item a ser procurado: "
                palavra = gets.chomp()

                if buscarPorCategoria == "n"
                    db = SQLite3::Database.open "db/database.db"
                    db.results_as_hash = true
                    itens = db.execute "SELECT ID, TITULO, CATEGORIA, DESCRICAO, STATUSDIARIO FROM Diario WHERE TITULO = '#{palavra}' OR DESCRICAO LIKE '%#{palavra}%' AND STATUSDIARIO <> 'CONCLUIDO'"
                    db.close
                    
                    itens.map {|item|
                        puts "Id: #{item['ID']} - Título: #{item['TITULO']}, Categoria: #{item['CATEGORIA']}, Descrição: #{item['DESCRICAO']}, Status: #{item['STATUSDIARIO']}"
                    }
                elsif buscarPorCategoria == "s"
                    db = SQLite3::Database.open "db/database.db"
                    db.results_as_hash = true
                    itens = db.execute "SELECT ID, TITULO, CATEGORIA, DESCRICAO, STATUSDIARIO FROM Diario WHERE CATEGORIA = '#{palavra}' AND STATUSDIARIO <> 'CONCLUIDO'"
                    db.close
                    
                    itens.map {|item|
                        puts "Id: #{item['ID']} - Título: #{item['TITULO']}, Categoria: #{item['CATEGORIA']}, Descrição: #{item['DESCRICAO']}, Status: #{item['STATUSDIARIO']}"
                    }
                end

                menu()
            elsif opcao == 4
                puts "Encerrando aplicação..."
            elsif opcao == 5
                print "Digite o Id do item que deverá ser excluído: "
                idItem = gets.chomp()

                db = SQLite3::Database.open "db/database.db"
                db.execute "DELETE FROM Diario WHERE ID = #{idItem}"
                db.close

                menu()
            elsif opcao == 6
                db = SQLite3::Database.open "db/database.db"
                db.results_as_hash = true
                itens = db.execute "SELECT ID, TITULO, CATEGORIA, DESCRICAO, STATUSDIARIO FROM Diario WHERE STATUSDIARIO = 'CONCLUIDO'"
                db.close

                itens.map {|item|
                    puts "Id: #{item['ID']} - Título: #{item['TITULO']}, Categoria: #{item['CATEGORIA']}, Descrição: #{item['DESCRICAO']}, Status: #{item['STATUSDIARIO']}"
                }

                menu()
            elsif opcao == 7
                print "Digite o Id do item que deverá ser finalizado:  "
                idItemFinalizado = gets.chomp()

                db = SQLite3::Database.open "db/database.db"
                db.execute "UPDATE Diario SET STATUSDIARIO = 'CONCLUIDO' WHERE ID = #{idItemFinalizado}"
                db.close

                menu()
            else
                puts "Opção inválida, selecione uma opção de 1 à 7"

                menu()
            end
            break
        end
    end

end

studyDiary = StudyDiary.new()
studyDiary.menu()