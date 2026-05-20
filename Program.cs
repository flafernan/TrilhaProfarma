using Microsoft.EntityFrameworkCore;
using ProfarmaApi;

var builder = WebApplication.CreateBuilder(args);

// 1. Configura a conexão com o Postgres usando a variável de ambiente do Docker Compose
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(connectionString));

builder.Services.AddHealthChecks();

var app = builder.Build();

// 2. Garante que o banco de dados será criado e alimentado ao subir o container
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.EnsureCreated(); // Cria o banco e a tabela se não existirem

    if (!db.Produtos.Any())
    {
        db.Produtos.AddRange(
            new Produto { Nome = "Medicamento A", Preco = 29.90m },
            new Produto { Nome = "Medicamento B", Preco = 15.50m }
        );
        db.SaveChanges();
    }
}

app.MapHealthChecks("/health");

// 3. NOVO ENDPOINT: Retorna os dados vindos direto do banco Postgres
app.MapGet("/produtos", async (AppDbContext db) =>
{
    return await db.Produtos.ToListAsync();
});

app.Run();