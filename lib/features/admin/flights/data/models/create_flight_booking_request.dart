class CreateFlightBookingRequest {
  final String id;
  final String airline;
  final String flightNo;
  final String from;
  final String to;
  final String departureTime;
  final String arrivalTime;
  final double price;
  final String status;
  final String customer;

  CreateFlightBookingRequest({
    required this.id,
    required this.airline,
    required this.flightNo,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.status,
    required this.customer,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'airline': airline,
      'flightNo': flightNo,
      'from': from,
      'to': to,
      'route': '$from - $to',
      'date': departureTime,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'price': price,
      'status': status,
      'customer': customer,
    };
  }
}
