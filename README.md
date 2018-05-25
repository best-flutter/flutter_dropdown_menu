# flutter_dropdown_menu

A dropdown menu for Flutter.

## Showcase

![showcase](https://github.com/jzoom/images/raw/master/dropdown_menu.gif)


## Installion

```

dropdown_menu : ^1.0.1

```


## Getting Started

It is easy to create dropdown menu like this:

```

 new DropdownMenu(
    menus: [
      new SizedBox(
        height: 200.0,
        child: ...
      ),

      new DropdownMenuBuilder(
        builder:(BuildContext context){
        },
        height:100.0
      )
    ],
    controller: new DropdownMenuController(),
    child: new ListView(
      children: [1,2,3,4,5,6,7,8,9,10].map((dynamic i){
        return new InkWell(
            onTap: () {
              print(new DateTime.now());
            },
            child: new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new Text("Fake content")));
      }).toList(),
    ),
  )


```
