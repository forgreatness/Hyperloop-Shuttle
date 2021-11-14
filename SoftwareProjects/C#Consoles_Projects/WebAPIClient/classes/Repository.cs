using System;
using System.Text.Json.Serialization;

namespace WebAPIClient
{
    public class Respository {
        [JsonPropertyName("name")]
        public string Name { get; set; }
    }
}