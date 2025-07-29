using System.Reflection;

namespace backend.Services
{
  public interface ISqlService
  {
    string GetSql(string name);
  }

  public class SqlService : ISqlService
  {
    private readonly Assembly _assembly;

    public SqlService()
    {
      _assembly = Assembly.GetExecutingAssembly();
    }

    public string GetSql(string name)
    {
      string resourceName = $"backend.Sql.{name}.sql";

      using Stream stream = _assembly.GetManifestResourceStream(resourceName) ?? throw new FileNotFoundException($"Embedded resource {resourceName} not found");

      using StreamReader reader = new(stream);

      return reader.ReadToEnd();
    }
  }
}