class CreateHotelBookingRequest {
  final String id;
  final String hotel;
  final String city;
  final String checkIn;
  final String checkOut;
  final String guests;
  final double price;
  final String status;
  final String customer;

  CreateHotelBookingRequest({
    required this.id,
    required this.hotel,
    required this.city,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.price,
    required this.status,
    required this.customer,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel': hotel,
      'city': city,
      'route': city,
      'date': checkIn,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'guests': guests,
      'price': price,
      'status': status,
      'customer': customer,
    };
  }
}
