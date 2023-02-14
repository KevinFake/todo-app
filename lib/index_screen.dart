import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todo.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  String _orderSelected = "";

  PickerDateRange? _selectedDate;

  _selectedDateDialog(PickerDateRange selectedDate) {
    _selectedDate = selectedDate;
  }

  _saveTodoDialog({Todo? todo}) {
    todo ??= Todo(time: DateTime.now());

    showDialog(
        context: context,
        builder: (context) => _SavetodoDialog(
              selectedRangeDate: _selectedDate,
              selectedDate:
                  todo!.id == 0 ? _selectedDate?.startDate : todo.time,
              todo: todo,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        toolbarHeight: 70,
        elevation: 5,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Todo",
              style: TextStyle(fontSize: 40, color: Colors.lightGreenAccent),
            ),
            Text(
              "App",
              style: TextStyle(fontSize: 40, color: Colors.white),
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Row(
              children: [
                DropdownButton(
                    items: <String>["By date", "By creation"]
                        .map((i) => DropdownMenuItem<String>(
                              value: i,
                              child: Text(
                                i,
                                style:
                                    const TextStyle(color: Colors.lightGreen),
                              ),
                            ))
                        .toList(),
                    hint: _orderSelected == ""
                        ? const Text(
                            "seleccionar",
                            style: TextStyle(color: Colors.white),
                          )
                        : Text(_orderSelected,
                            style: const TextStyle(color: Colors.white)),
                    onChanged: (value) {
                      setState(() {
                        _orderSelected = value.toString();
                      });
                    }),
                const _UserAvatar()
              ],
            ),
          )
        ],
      ),
      body: _Content(
          key: Key(_orderSelected),
          saveTodoDialog: _saveTodoDialog,
          selectedDateDialog: _selectedDateDialog,
          order: _orderSelected),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        onPressed: () {
          _saveTodoDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: AssetImage("lib/assets/images/user.png"),
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return _ProfileDialog();
            });
      },
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  final Function confirm;
  final String message;

  const _ConfirmDialog(
      {Key? key, required this.confirm, this.message = "confirm"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("porfavor confirma"),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () {
              // eliminar pendiente
              confirm();
              Navigator.of(context).pop();
            },
            child: const Text("Si")),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("No"))
      ],
    );
  }
}

class _ProfileDialog extends StatelessWidget {
  final _Key = GlobalKey<FormState>();
  final _KeyColumn = GlobalKey<FormState>();

  final _NameControler = TextEditingController();
  final _AvatarControler = TextEditingController();
  _ProfileDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 100,
          maxHeight: 290,
          minWidth: 100,
          maxWidth: 450,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          height: MediaQuery.of(context).size.height * .5,
          child: Form(
            key: _Key,
            child: SingleChildScrollView(
              child: Column(
                key: _KeyColumn,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("assets/images/user.png"),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Ingresa tu nombre",
                        border: OutlineInputBorder()),
                    controller: _NameControler,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Ingresa tu apellido",
                        border: OutlineInputBorder()),
                    controller: _AvatarControler,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.lightGreen,
                        elevation: 4,
                      ),
                      onPressed: () {
                        final sizeWidget = _Key.currentContext!.size;
                        print(sizeWidget);
                      },
                      child: const Text("Update"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SavetodoDialog extends StatefulWidget {
  _SavetodoDialog(
      {Key? key, this.selectedRangeDate, this.selectedDate, required this.todo})
      : super(key: key);

  DateTime? selectedDate;
  final PickerDateRange? selectedRangeDate;
  final Todo todo;

  @override
  State<_SavetodoDialog> createState() => _SavetodoDialogState();
}

class _SavetodoDialogState extends State<_SavetodoDialog> {
  final _key = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _textController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.todo.title;
    _textController.text = widget.todo.content;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ConstrainedBox(
        constraints: const BoxConstraints(
            minWidth: 100, maxWidth: 450, minHeight: 100, maxHeight: 700),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Form(
              key: _key,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("lib/assets/images/user.png"),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Nombre", border: OutlineInputBorder()),
                      controller: _nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "dabes poner un nombre a la tarea";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      minLines: 3,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          labelText: "Texto", border: OutlineInputBorder()),
                      controller: _textController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "dabes poner una descripcion a la tarea";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SfDateRangePicker(
                        selectionColor: Colors.lightGreenAccent,
                        selectionMode: DateRangePickerSelectionMode.single,
                        initialSelectedDate: widget.selectedDate == null
                            ? DateTime.now()
                            : widget.selectedDate!,
                        onSelectionChanged: (dateRangePickerSelection) {
                          print(dateRangePickerSelection.value);
                          widget.selectedDate = dateRangePickerSelection.value;
                          setState(() {});
                        }),
                    if (widget.selectedDate == null)
                      const Text(
                        "Por Favor, slecciona una fecha",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            print("Guardar");
                          }
                          print(widget.selectedDate);
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.lightGreen,
                          elevation: 4,
                        ),
                        child: const Text("Guardar"))
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  Function saveTodoDialog;
  Function selectedDateDialog;
  String order;

  _Content(
      {Key? key,
      required this.saveTodoDialog,
      required this.selectedDateDialog,
      required this.order})
      : super(key: key);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  bool _showImg = true;

  List<Todo> todos = [];
  List<Todo> todosFiltered = [];

  @override
  void initState() {
    super.initState();

    todos.addAll([
      Todo(
          id: 5,
          title: "test 1",
          content: "Content test",
          time: DateTime.now().subtract(const Duration(days: 2))),
      Todo(
          id: 3,
          title: "test 2",
          content: "Content test",
          time: DateTime.now().subtract(const Duration(days: 5))),
      Todo(
          id: 8,
          title: "test 3",
          content: "Content test",
          time: DateTime.now()),
      Todo(
          id: 2,
          title: "test 4",
          content: "Content test",
          time: DateTime.now().add(const Duration(days: 2))),
      Todo(
          id: 5,
          title: "test 5",
          content: "Content test",
          time: DateTime.now()),
      Todo(
          id: 0,
          title: "test 6",
          content: "Content test",
          time: DateTime.now().subtract(const Duration(days: 7))),
      Todo(
          id: 50,
          title: "test 7",
          content: "Content test",
          time: DateTime.now()),
      Todo(
          id: 45,
          title: "test 8",
          content: "Content test",
          time: DateTime.now().add(const Duration(days: 5))),
    ]);

    todosFiltered = todos;

    if (widget.order == "by date") {
      todosFiltered.sort(((a, b) => a.time.compareTo(b.time)));
    } else {
      todosFiltered.sort(((a, b) => a.id.compareTo(b.id)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 1 * 6,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("mostrar imagen"),
                  Checkbox(
                      value: _showImg,
                      onChanged: (value) {
                        _showImg = value!;
                        setState(() {});
                      }),
                ],
              ),
              SfDateRangePicker(
                  selectionColor: Colors.lightGreenAccent,
                  startRangeSelectionColor: Colors.green,
                  endRangeSelectionColor: Colors.green,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 3)),
                    DateTime.now().add(const Duration(days: 3)),
                  ),
                  rangeSelectionColor: Colors.lightGreenAccent,
                  showActionButtons: true,
                  onCancel: () {
                    todosFiltered = todos;
                    setState(() {});
                  },
                  confirmText: "Establecer",
                  cancelText: "Cancelar",
                  onSubmit: (dateRange) {
                    todosFiltered = [];
                    if (dateRange is PickerDateRange) {
                      for (var i = 0; i < todos.length; i++) {
                        if (todos[i].time.compareTo(dateRange.startDate!) >=
                                0 &&
                            todos[i].time.compareTo(dateRange.endDate!) <= 0) {
                          todosFiltered.add(todos[i]);
                        }
                      }

                      setState(() {});
                    }

                    print(dateRange);
                  },
                  onSelectionChanged: (dateRange) {
                    print(dateRange.value);
                    widget.selectedDateDialog(dateRange.value);
                  }),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                style: ElevatedButton.styleFrom(primary: Colors.lightGreen),
                label: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Añadir pendiente",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                onPressed: () {
                  widget.saveTodoDialog();
                },
              )
            ],
          )),
      Expanded(
          flex: 2 * 5,
          child: todosFiltered.isEmpty
              ? const _PageEmpty()
              : ListView.builder(
                  itemCount: todosFiltered.length,
                  itemBuilder: ((context, index) => ListTile(
                        title: Card(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                width: _showImg ? 70 : 0,
                                duration: const Duration(milliseconds: 250),
                                child: const Image(
                                    image: AssetImage(
                                        "lib/assets/images/producto.png")),
                              ),
                              GestureDetector(
                                onTap: (() => widget
                                    .saveTodoDialog(todosFiltered[index])),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        todosFiltered[index].title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Row(
                                          children: [
                                            Text(
                                                "${todosFiltered[index].time.day}-${todosFiltered[index].time.month}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.grey.shade800)),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Text(todosFiltered[index].content),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        leading: const Icon(Icons.check_circle_outline,
                            color: Colors.green),
                        trailing: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => _ConfirmDialog(
                                      message:
                                          "¿deseas eliminar este pendiente?",
                                      confirm: () {
                                        todos.remove(todosFiltered[index]);
                                        setState(() {});
                                      }));
                            },
                            child:
                                Icon(Icons.delete, color: Colors.red.shade700)),
                      ))))
    ]);
  }
}

class _PageEmpty extends StatelessWidget {
  const _PageEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.lightGreen.shade100, shape: BoxShape.circle),
        child: const Center(
            child: Text(
          "Sin tareas pendientes",
          style: TextStyle(
              color: Colors.green,
              fontStyle: FontStyle.italic,
              fontSize: 25,
              fontWeight: FontWeight.w100),
        )),
      ),
    );
  }
}
