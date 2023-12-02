This is a JSON Schema example.

File name: `[name].json` (In snake_case)
DTO name: `[Name]` (In upper camel case)
Schema:
```
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "[DTOy] Schema",
    "description": "Schema for [DTO] data validation",
    "type": "object",
    "properties": {
      "[property_1]": {
        "type": "[type]",
        "description": "[Description of property_1]"
      },
      "[property_2]": {
        "type": "[type]",
        "description": "[Description of property_2]",
        "format": "[optional format]"
      }
      // Add additional properties as needed
    },
    "required": ["[property_1]", "[property_2]" /*, ... other required properties */]
}
```