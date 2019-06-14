import 'recipes_provider.dart';

class LocalRecipeProvider implements RecipeProvider {
  final Map<String, List<String>> ingredientUrls = {
    'cheese': [
      'https://www.bbcgoodfood.com/recipes/1803634/brie-wrapped-in-prosciutto-and-brioche',
      'https://www.bbcgoodfood.com/recipes/triple-cheese-bacon-dauphinoise',
      'https://www.bbcgoodfood.com/recipes/melty-cheese-potato-pie',
      'https://www.bbcgoodfood.com/recipes/melty-cheese-fondue-pot',
      'https://www.bbcgoodfood.com/recipes/1185/mary-cadogans-tartiflette',
      'https://www.bbcgoodfood.com/recipes/beer-mac-n-cheese',
      'https://www.bbcgoodfood.com/recipes/1759659/bonfire-night-baked-potatoes',
      'https://www.bbcgoodfood.com/recipes/membrillo-chorizo-cheddar-toastie',
      'https://www.bbcgoodfood.com/recipes/baked-camembert-bacon-wrapped-breadsticks',
      'https://www.bbcgoodfood.com/recipes/triple-cheese-aubergine-lasagne',
    ],
    'orange': [
      'https://www.bbcgoodfood.com/recipes/8760/orange-sorbet',
      'https://www.bbcgoodfood.com/recipes/collection/orange-cake',
      'https://www.bbcgoodfood.com/recipes/144607/orange-cranachan',
      'https://www.bbcgoodfood.com/recipes/12341/orange-polenta-cake',
    ],
    'cauliflower': [
      'https://www.bbcgoodfood.com/recipes/358608/cauliflower-cheese',
      'https://www.bbcgoodfood.com/recipes/1713636/spicy-cauliflower',
      'https://www.bbcgoodfood.com/recipes/cauliflower-rice',
      'https://www.bbcgoodfood.com/recipes/1439/cauliflower-with-shrimps',
      'https://www.bbcgoodfood.com/recipes/2638/cauliflower-tempura',
    ],
    'bacon': [
      'https://www.bbcgoodfood.com/recipes/3505/leek-bacon-and-potato-soup',
      'https://www.bbcgoodfood.com/recipes/1221/easy-risotto-with-bacon-and-peas',
      'https://www.bbcgoodfood.com/recipes/2303681/creamy-courgette-and-bacon-pasta-',
      'https://www.bbcgoodfood.com/recipes/2329/bacon-and-mushroom-pasta',
    ],
    'fish': [
      'https://www.bbcgoodfood.com/recipes/3174/fish-pie-in-four-steps',
      'https://www.bbcgoodfood.com/recipes/1031/thaistyle-steamed-fish',
      'https://www.bbcgoodfood.com/recipes/fish-mappas',
      'https://www.bbcgoodfood.com/recipes/3146683/fish-tacos',
    ],
    'onion': [
      'https://www.bbcgoodfood.com/recipes/3366/sea-bass-with-sizzled-ginger-chilli-and-spring-oni',
      'https://www.bbcgoodfood.com/recipes/onion-rings',
      'https://www.bbcgoodfood.com/recipes/stuffed-onions',
      'https://www.bbcgoodfood.com/recipes/6291/sticky-onion-and-cheddar-quiche',
      'https://www.bbcgoodfood.com/recipes/1404/red-onion-marmalade',
      'https://www.bbcgoodfood.com/recipes/3056/sausage-sage-and-onion-stuffing',
      'https://www.bbcgoodfood.com/recipes/2927/sausages-with-sticky-onion-gravy',
    ],
    'eggs': [],
    'flour': [],
    'ham': [],
    'meat': [],
    'sausage': [],
    'baguette': [],
    'toast': [],
    'shrimp': [
      'https://www.bbcgoodfood.com/recipes/cajun-fried-shrimp',
      'https://www.bbcgoodfood.com/recipes/10990/cauliflower-carpaccio-with-morecambe-bay-shrimps-a',
      'https://www.bbcgoodfood.com/recipes/4402/prawn-curry-in-a-hurry',
      'https://www.bbcgoodfood.com/recipes/7418/easy-thai-prawn-curry',
      'https://www.bbcgoodfood.com/recipes/prawn-katsu-burgers',
      'https://www.bbcgoodfood.com/recipes/spaghetti-chilli-prawns-salami-gremolata-breadcrumbs',
      'https://www.bbcgoodfood.com/recipes/8049/prawn-spring-roll-wraps',
      'https://www.bbcgoodfood.com/recipes/7739/lemony-prawn-and-pea-risotto',
    ],
    'pickles': [],
    'aubergine': [],
    'beans': [],
    'broccoli': [],
    'cabbage': [],
    'carrot': [],
    'chives': [],
    'salad': [],
    'corn': [],
    'cucumber': [],
    'garlic': [
      'https://www.bbcgoodfood.com/recipes/7552/sausage-casserole-with-garlic-toasts',
      'https://www.bbcgoodfood.com/recipes/10130/cheesy-garlic-bread',
      'https://www.bbcgoodfood.com/recipes/2496/garlic-and-basil-ciabatta',
      'https://www.bbcgoodfood.com/recipes/5139/garlic-mash-potato-bake',
      'https://www.bbcgoodfood.com/recipes/2896/cheese-and-garlicfilled-mushrooms',
      'https://www.bbcgoodfood.com/recipes/linguine-garlic-butter-prawns',
      'https://www.bbcgoodfood.com/recipes/10608/garlic-bread-toasts',
    ],
    'pumpkin': [],
    'radish': [],
    'tomato': [],
    'pepper': [],
    'apple': [],
    'banana': [],
    'blueberries': [],
    'cherries': [],
    'grapes': [],
    'lemon': [],
    'lime': [],
    'peach': [],
    'pear': [],
    'pomegranate': [],
    'raspberry': [],
    'strawberry': [
      'https://www.bbcgoodfood.com/recipes/3161704/strawberry-jam',
      'https://www.bbcgoodfood.com/recipes/rhubarb-strawberry-vodka',
      'https://www.bbcgoodfood.com/recipes/6375/strawberry-and-prosecco-jellies',
      'https://www.bbcgoodfood.com/recipe/polka-dot-strawberry-cake',
      'https://www.bbcgoodfood.com/recipes/10876/strawberry-cream-tea-cake',
      'https://www.bbcgoodfood.com/recipes/avocado-strawberry-smoothie',
      'https://www.bbcgoodfood.com/recipes/3133/salmon-strawberry-and-fennel-salad',
      'https://www.bbcgoodfood.com/recipe/strawberry-rhubarb-crumble',
    ],
    'watermelon': [],
    'chocolate': [],
    'honey': [],
    'jam': [],
    'jelly': [
      'https://www.bbcgoodfood.com/recipes/11249/red-white-and-blue-jellies',
      'https://www.bbcgoodfood.com/recipes/peanut-butter-jelly-cookies',
      'https://www.bbcgoodfood.com/recipes/watermelon-vodka-jelly-shots',
      'https://www.bbcgoodfood.com/recipes/fresh-raspberry-jelly',
      'https://www.bbcgoodfood.com/recipes/1409/damson-jelly',
    ],
  };

  Future<Iterable<String>> getUrlStreamFor(String ingredient) async {
    return ingredientUrls[ingredient];
  }

  @override
  Stream<Iterable<String>> recipeUrlStream(String ingredient) {
    return Stream.fromFuture(getUrlStreamFor(ingredient));
  }
}