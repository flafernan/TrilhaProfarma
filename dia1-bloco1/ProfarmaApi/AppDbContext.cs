using Microsoft.EntityFrameworkCore;

namespace ProfarmaApi
{
    // Classe que representa a nossa tabela de Produtos no banco
    public class Produto
    {
        public int Id { get; set; }
        public string Nome { get; set; } = string.Empty;
        public decimal Preco { get; set; }
    }

    // O Contexto que gerencia a conexão com o banco de dados
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Produto> Produtos { get; set; }
    }
}