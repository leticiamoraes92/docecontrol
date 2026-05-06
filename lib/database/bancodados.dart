import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BancoDados {
  // Versão 4: Incluída a tabela mercado para lista de compras
  static Future<Database> abrirBanco() async {
    String caminho = join(await getDatabasesPath(), 'doce_control.db');

    return openDatabase(
      caminho,
      version: 4,
      onCreate: (db, version) async {
        // Tabela de Clientes
        await db.execute('CREATE TABLE clientes (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, telefone TEXT)');

        // Tabela de Decorações/Doces
        await db.execute('CREATE TABLE decoracoes (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, valor REAL)');

        // Tabela de Pedidos completa
        await db.execute('''
          CREATE TABLE pedidos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_cliente INTEGER,
            id_decoracao INTEGER,
            quantidade INTEGER,
            total REAL,
            entrada REAL,
            restante REAL,
            massa TEXT,
            data TEXT,
            horario TEXT,
            tipo_entrega TEXT,
            endereco TEXT,
            valor_entrega REAL, 
            observacao TEXT,
            status TEXT DEFAULT 'Pendente'
          )
        ''');

        // Nova Tabela: Mercado (Lista de Compras)
        await db.execute('''
          CREATE TABLE mercado (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            item TEXT, 
            comprado INTEGER DEFAULT 0
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          try {
            await db.execute("ALTER TABLE pedidos ADD COLUMN status TEXT DEFAULT 'Pendente'");
            await db.execute("ALTER TABLE pedidos ADD COLUMN observacao TEXT");
          } catch (e) { print("Erro na migração v2: $e"); }
        }
        if (oldVersion < 3) {
          try {
            await db.execute("ALTER TABLE pedidos ADD COLUMN valor_entrega REAL DEFAULT 0.0");
          } catch (e) { print("Erro na migração v3: $e"); }
        }
        // Migração para Versão 4: Criação da tabela de mercado se não existir
        if (oldVersion < 4) {
          try {
            await db.execute('''
              CREATE TABLE mercado (
                id INTEGER PRIMARY KEY AUTOINCREMENT, 
                item TEXT, 
                comprado INTEGER DEFAULT 0
              )
            ''');
          } catch (e) { print("Erro na migração v4: $e"); }
        }
      },
    );
  }

  // --- MÉTODOS DE CLIENTES ---
  static Future<void> inserirCliente(String nome, String telefone) async {
    final db = await abrirBanco();
    await db.insert('clientes', {'nome': nome, 'telefone': telefone});
  }

  static Future<List<Map<String, dynamic>>> listarClientes() async {
    final db = await abrirBanco();
    return await db.query('clientes', orderBy: 'nome ASC');
  }

  // --- MÉTODOS DE DECORAÇÕES ---
  static Future<void> inserirDecoracao(String nome, double valor) async {
    final db = await abrirBanco();
    await db.insert('decoracoes', {'nome': nome, 'valor': valor});
  }

  static Future<List<Map<String, dynamic>>> listarDecoracoes() async {
    final db = await abrirBanco();
    return await db.query('decoracoes', orderBy: 'nome ASC');
  }

  static Future<void> atualizarDecoracao(int id, String nome, double valor) async {
    final db = await abrirBanco();
    await db.update('decoracoes', {'nome': nome, 'valor': valor}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deletarDecoracao(int id) async {
    final db = await abrirBanco();
    await db.delete('decoracoes', where: 'id = ?', whereArgs: [id]);
  }

  // --- MÉTODOS DE PEDIDOS (AGENDAMENTOS) ---
  static Future<void> inserirPedido(
      int idCliente, int idDecoracao, String observacao, int quantidade,
      double total, double entrada, double restante, String massa,
      String data, String horario, String tipoEntrega, String endereco, double valorEntrega,
      ) async {
    final db = await abrirBanco();
    await db.insert('pedidos', {
      'id_cliente': idCliente,
      'id_decoracao': idDecoracao,
      'quantidade': quantidade,
      'total': total,
      'entrada': entrada,
      'restante': restante,
      'massa': massa,
      'data': data,
      'horario': horario,
      'tipo_entrega': tipoEntrega,
      'endereco': endereco,
      'valor_entrega': valorEntrega,
      'observacao': observacao,
      'status': 'Pendente',
    });
  }

  static Future<List<Map<String, dynamic>>> listarPedidos() async {
    final db = await abrirBanco();
    return await db.rawQuery('''
      SELECT p.*, c.nome as nome_cliente, d.nome as nome_doce 
      FROM pedidos p
      JOIN clientes c ON p.id_cliente = c.id
      JOIN decoracoes d ON p.id_decoracao = d.id
      ORDER BY p.id DESC
    ''');
  }

  static Future<void> atualizarStatusPedido(int id, String novoStatus) async {
    final db = await abrirBanco();
    await db.update('pedidos', {'status': novoStatus}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> excluirPedido(int id) async {
    final db = await abrirBanco();
    await db.delete('pedidos', where: 'id = ?', whereArgs: [id]);
  }

  // --- MÉTODOS DE RELATÓRIO ---
  static Future<List<Map<String, dynamic>>> buscarRelatorioMensal(int mes, int ano) async {
    final db = await abrirBanco();
    String mesFormatado = mes.toString().padLeft(2, '0');

    return await db.rawQuery('''
      SELECT p.*, c.nome as nome_cliente, d.nome as nome_doce 
      FROM pedidos p
      JOIN clientes c ON p.id_cliente = c.id
      JOIN decoracoes d ON p.id_decoracao = d.id
      WHERE p.data LIKE '%/$mesFormatado/$ano'
      ORDER BY p.data ASC
    ''');
  }

  // --- MÉTODOS DE MERCADO (LISTA DE COMPRAS) ---
  static Future<void> inserirItemMercado(String item) async {
    final db = await abrirBanco();
    await db.insert('mercado', {'item': item, 'comprado': 0});
  }

  static Future<List<Map<String, dynamic>>> listarItensMercado() async {
    final db = await abrirBanco();
    return await db.query('mercado', orderBy: 'comprado ASC, id DESC');
  }

  static Future<void> alternarStatusItem(int id, int status) async {
    final db = await abrirBanco();
    await db.update('mercado', {'comprado': status}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> excluirItemMercado(int id) async {
    final db = await abrirBanco();
    await db.delete('mercado', where: 'id = ?', whereArgs: [id]);
  }
}