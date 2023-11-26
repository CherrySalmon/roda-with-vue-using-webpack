This is a JSON Schema example.

File name: `[entity's name]_schema.json` (In snake_case)
Entity name: `[entity's name]Schema` (In upper camel case)
Schema:
```
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "[Entity] Schema",
    "description": "Schema for [Entity] data validation",
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