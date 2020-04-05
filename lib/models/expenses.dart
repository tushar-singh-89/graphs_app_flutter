class Expenses {
  final String color;
  final String display;
  final String subtitle;
  final String title;
  final double value;
  Expenses(this.color, this.display, this.subtitle, this.title, this.value);

  Expenses.fromMap(Map<String, dynamic> map)
      : assert(map['display'] != null),
        assert(map['title'] != null),
        assert(map['value'] != null),
        assert(map['subtitle'] != null),
        assert(map['color'] != null),
        color = map['color'],
        display = map['display'],
        subtitle = map['subtitle'],
        title = map['title'],
        value = map['value'];

  @override
  String toString() => "Record<$display:$title:$value>";
}
