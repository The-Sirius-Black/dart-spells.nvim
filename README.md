# DART-SPELLS

`dart-spells` is a Neovim plugin designed to help Flutter development.

## Installation

To install `dart-spells`, use your favorite plugin manager. 

Example using Lazy:

```lua
return {
	"The-Sirius-Black/dart-spells.nvim",
	config = function()
		local spells = require("dart-spells")

		vim.keymap.set("n", "key", spells.wrap_with_bloc_builder, {})

		vim.keymap.set("n", "key", spells.wrap_with_bloc_consumer, {})

		vim.keymap.set("n", "key", spells.wrap_with_bloc_listener, {})

		vim.keymap.set("n", "key", spells.wrap_with_bloc_provider, {})

		vim.keymap.set("n", "key", spells.wrap_with_multi_bloc_provider, {})

		-- vim.keymap.set("n", "key", spells.wrap_with_builder(replacment_text, callback), {})

		-- vim.keymap.set("n", "key", spells.wrap_with_widget(replacment_text, callback), {})
	end,
}
```


## Features

### 1. Widget Wrapping       

#### Predefined Functions 

The plugin includes several predefined functions to assist with using Bloc.<br>
These functions allow quick wrapping of widgets with Bloc widgets.<br>
The available functions are:

```lua
require("dart-spells").wrap_with_bloc_builder()
```

```lua
require("dart-spells").wrap_with_bloc_consumer()
```

```lua
require("dart-spells").wrap_with_bloc_listener()
```

```lua
require("dart-spells").wrap_with_bloc_provider()
```

```lua
require("dart-spells").wrap_with_multi_bloc_provider()
```
<br>

# Custom Widget Wrapping

The plugin provides two functions: `wrap_with_widget` and `wrap_with_builder`.

## wrap_with_widget

The `wrap_with_widget` function allows you to wrap a selected widget with a specified widget structure. It takes two parameters:

- **replacement_text**: A string that specifies the structure to use for wrapping the selected widget code.
- **callback**: (Optional) A callback function that can be used to perform additional operations after wrapping.

### How It Works

The `replacement_text` parameter only affects the portion of the code that is wrapped. It does not alter any other parts of the widget code outside of the wrapping structure.

### Example

Consider the following  code:

```dart
Container(
    child: Text(
        "Hello, World!"
    )
)
```
The function returns widget above wrapped as a child whose parent is  your replacement string parameter.

For example:

If a `replacement_text` is `"MyWidget("`, the resulting code will look like this:

```dart
MyWidget(
    child: Container(
        child: Text(
            "Hello, World!"
        )
    )
)
```


### Important Note

- The function will automatically add the closing bracket and the `child:` keyword. The rest of the code is up to you to fill in as needed.


```dart
    child: Container(
        child: Text(
            "Hello, World!"
        )
    )
)
```

## wrap_with_builder

The `wrap_with_builder` function allows you to wrap a selected widget with a specified builder structure. It takes two parameters:

- **replacement_text**: A string that specifies the structure to use for wrapping the selected widget code.
- **callback**: (Optional) A callback function that can be used to perform additional operations after wrapping.

### How It Works

The `replacement_text` parameter only affects the portion of the code that is wrapped. It does not alter any other parts of the widget code outside of the wrapping structure.

### Example

Consider the following widget code:

```dart
Container(
    child: Text(
        "Hello, World!"
    )
)
```

If  a `replacement_text` is `"BlocBuilder(builder: (context,state) {"`, the resulting code will look like this:

```dart
BlocBuilder(
    builder: (context,state) {
        return Container(
            child: Text(
                "Hello, World!"
            )   
        ),
    },
);
```

### Important Note

- The function will automatically add the closing bracket and the `return` keyword. The rest of the code is up to you to fill in as needed.


```dart
        return Container(
            child: Text(
                "Hello, World!"
            )
        ),
    }
)
```
