db = db.getSiblingDB('mongo_incluses');  // Cria ou acessa o banco 'mongo_incluses'

// Insere documentos na coleção 'funcoes'
db.funcoes.insertMany([
  {  id: "uuid1", nome: "Administrador", userIds: [1] },
  {  id: "uuid2", nome: "Desenvolvedor" },
  {  id: "uuid3", nome: "Designer" },
  {  id: "uuid4", nome: "Gerente de Projetos" }
]);
