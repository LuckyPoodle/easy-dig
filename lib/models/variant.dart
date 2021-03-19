class Variant{

  String name;
 
  String quantity;
  String price;
  String imageUrlfromStorage;

  Variant({
    this.name,
    this.price,
    this.quantity,
    this.imageUrlfromStorage
  });

   factory Variant.fromMap(Map data) {
    return Variant(
        name: data['variantname'] ?? '',
      price:data['variantprice'] ?? '',
      quantity: data['quantity'] ?? '',
      imageUrlfromStorage: data['imageUrlfromStorage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'variantname': name,
      'variantprice': price,
      'quantity': quantity,
      'imageUrlfromStorage':imageUrlfromStorage
    };
  }




}