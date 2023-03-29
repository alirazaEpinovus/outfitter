import 'package:outfitters/Models/ProductsModel.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetailBloc {
  List<Variantnode> list = [];
  final _productVariants = PublishSubject<List<Variantnode>>();

  Stream<List<Variantnode>> get getProductVariants => _productVariants.stream;

  initList() {
    list = [];
    _productVariants.sink.add(list);
  }

  addProductVariant(Variantnode variantnode) {
    // print("Length :: ${list.length} Called");
    list.add(variantnode);
    _productVariants.sink.add(list);
  }

  

  dispose() {
    _productVariants.close();
  }
}

final productDetailBloc = ProductDetailBloc();
