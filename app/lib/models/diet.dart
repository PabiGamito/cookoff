class Diet {
  final String name;
  final String iconicIngredient;
  final Iterable<String> filteredIngredients;

  Diet(this.name, this.filteredIngredients, this.iconicIngredient);
}

// Null diet
class NoDiet extends Diet {
  NoDiet() : super("All", [], 'meat');
}
