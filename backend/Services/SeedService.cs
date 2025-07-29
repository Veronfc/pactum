using System.Reflection;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace backend.Services
{
    public interface ISeedService
    {
        object GetSeedData(Type type, string name);
    }

    public class SeedService : ISeedService
    {
        private readonly Assembly _assembly = Assembly.GetExecutingAssembly();

        public object GetSeedData(Type type, string name)
        {
            string resourceName = $"backend.SeedData.{name}.json";

            using Stream stream = _assembly.GetManifestResourceStream(resourceName) ?? throw new FileNotFoundException($"Embedded resource {resourceName}.json not found");

            using StreamReader reader = new(stream);

            string data = reader.ReadToEnd();
            Type listType = typeof(List<>).MakeGenericType(type);

            return JsonSerializer.Deserialize(data, listType, new JsonSerializerOptions { PropertyNameCaseInsensitive = true, Converters = { new JsonStringEnumConverter(JsonNamingPolicy.SnakeCaseLower) } })!;
        }
    }
}