class Diet {
  final String name;
  final Iterable<String> filteredIngredients;

  Diet(this.name, this.filteredIngredients);
}

// Null diet
class NoDiet extends Diet {
  NoDiet() : super("None", []);
}
