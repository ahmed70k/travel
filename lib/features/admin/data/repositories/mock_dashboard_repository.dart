import '../../domain/entities/dashboard_models.dart';

class MockDashboardRepository {
  List<StatModel> getStats() {
    return [
      StatModel(
        title: 'إجمالي الحجوزات',
        value: '1,284',
        changeLabel: '+12% عن الشهر الماضي',
        isPositive: true,
        progress: 1.0,
      ),
      StatModel(
        title: 'إجمالي الأرباح',
        value: '348.5k\$',
        changeLabel: '+8% عن الشهر الماضي',
        isPositive: true,
        progress: 0.75,
      ),
      StatModel(
        title: 'العملاء B2C',
        value: '892',
        changeLabel: '+45 جديد',
        isPositive: true,
        progress: 0.66,
      ),
      StatModel(
        title: 'الوكلاء B2B',
        value: '47',
        changeLabel: '+6 وكلاء جدد',
        isPositive: true,
        progress: 0.5,
      ),
    ];
  }

  List<BookingModel> getRecentBookings() {
    return [
      BookingModel(
        id: 'BK-1001',
        clientName: 'محمد علي',
        flightPath: 'جدة ← القاهرة',
        date: '2025-05-20',
        price: '320\$',
        status: BookingStatus.confirmed,
      ),
      BookingModel(
        id: 'BK-1002',
        clientName: 'سارة أحمد',
        flightPath: 'دبي ← لندن',
        date: '2025-05-22',
        price: '850\$',
        status: BookingStatus.pending,
      ),
      BookingModel(
        id: 'BK-1003',
        clientName: 'خالد يوسف',
        flightPath: 'الرياض ← اسطنبول',
        date: '2025-05-25',
        price: '410\$',
        status: BookingStatus.issued,
      ),
      BookingModel(
        id: 'BK-1004',
        clientName: 'نورة خالد',
        flightPath: 'القاهرة ← نيويورك',
        date: '2025-06-01',
        price: '1,250\$',
        status: BookingStatus.confirmed,
      ),
    ];
  }

  List<TopB2bModel> getTopB2b() {
    return [
      TopB2bModel(
        name: 'السفر العربية',
        bookings: '142 حجز',
        revenue: '46,200\$',
      ),
      TopB2bModel(name: 'ماس للسياحة', bookings: '98 حجز', revenue: '31,750\$'),
      TopB2bModel(
        name: 'السفر الذهبي',
        bookings: '67 حجز',
        revenue: '22,300\$',
      ),
    ];
  }

  List<ProviderModel> getProviders() {
    return [
      ProviderModel(
        name: 'Amadeus GDS',
        type: 'الطيران - GDS',
        apiKeyPartial: 'amad*******',
        requestsToday: 2340,
        status: ProviderStatus.active,
      ),
      ProviderModel(
        name: 'HotelBeds',
        type: 'الفنادق',
        apiKeyPartial: 'hotel*******',
        requestsToday: 5672,
        status: ProviderStatus.active,
      ),
      ProviderModel(
        name: 'Booking.com',
        type: 'فنادق وعروض',
        apiKeyPartial: 'booki*******',
        requestsToday: 890,
        status: ProviderStatus.trial,
      ),
    ];
  }

  List<OfferModel> getOffers() {
    return [
      OfferModel(
        name: 'عرض الصيف',
        type: 'طيران',
        discount: '20%',
        period: '01/06 - 31/08',
        isActive: true,
      ),
      OfferModel(
        name: 'عرض الوكالات B2B',
        type: 'فنادق',
        discount: '15%',
        period: 'دائم',
        isActive: true,
      ),
      OfferModel(
        name: 'الحجز المبكر',
        type: 'طيران + فندق',
        discount: '10%',
        period: 'حتى 30/05',
        isActive: false,
      ),
    ];
  }

  List<StatModel> getFlightStats() {
    return [
      StatModel(
        title: 'إجمالي حجوزات الطيران',
        value: '1,284',
        changeLabel: '',
        isPositive: true,
        progress: 1.0,
      ),
      StatModel(
        title: 'إيرادات الطيران',
        value: '482k\$',
        changeLabel: '',
        isPositive: true,
        progress: 0.8,
      ),
      StatModel(
        title: 'معدل الإشغال',
        value: '86%',
        changeLabel: '',
        isPositive: true,
        progress: 0.86,
      ),
      StatModel(
        title: 'شركاء الطيران',
        value: '12',
        changeLabel: '',
        isPositive: true,
        progress: 0.5,
      ),
    ];
  }

  List<DetailedFlightBooking> getDetailedFlightBookings() {
    return [
      DetailedFlightBooking(
        id: 'FL-1024',
        airlineName: 'الخطوط القطرية',
        airlineCode: 'QR 217',
        flightType: 'رحلة مباشرة',
        departureTime: '09:30',
        departureAirport: 'الدوحة (DOH)',
        arrivalTime: '13:15',
        arrivalAirport: 'القاهرة (CAI)',
        duration: '3 ساعات 45 د',
        price: '380\$',
        status: BookingStatus.confirmed,
        passengerName: 'محمد علي',
        passengerCount: 2,
        flightClass: 'اقتصادي',
      ),
      DetailedFlightBooking(
        id: 'FL-2108',
        airlineName: 'الاتحاد للطيران',
        airlineCode: 'EY 98',
        flightType: 'توقف واحد',
        departureTime: '22:15',
        departureAirport: 'أبوظبي (AUH)',
        arrivalTime: '05:35',
        arrivalAirport: 'لندن (LHR)',
        duration: '7 ساعات 20 د',
        price: '1,150\$',
        status: BookingStatus.payment_pending,
        passengerName: 'سارة أحمد',
        passengerCount: 1,
        flightClass: 'درجة رجال أعمال',
      ),
      DetailedFlightBooking(
        id: 'FL-9823',
        airlineName: 'طيران الإمارات',
        airlineCode: 'EK 304',
        flightType: 'رحلة مباشرة',
        departureTime: '08:00',
        departureAirport: 'دبي (DXB)',
        arrivalTime: '12:15',
        arrivalAirport: 'اسطنبول (IST)',
        duration: '4 ساعات 15 د',
        price: '520\$',
        status: BookingStatus.confirmed,
        passengerName: 'خالد يوسف',
        passengerCount: 3,
        flightClass: 'اقتصادي مميز',
      ),
    ];
  }

  List<StatModel> getHotelStats() {
    return [
      StatModel(
        title: 'إجمالي حجوزات الفنادق',
        value: '892',
        changeLabel: '',
        isPositive: true,
        progress: 1.0,
      ),
      StatModel(
        title: 'إيرادات الفنادق',
        value: '276k\$',
        changeLabel: '',
        isPositive: true,
        progress: 0.74,
      ),
      StatModel(
        title: 'متوسط الإشغال',
        value: '74%',
        changeLabel: '',
        isPositive: true,
        progress: 0.74,
      ),
      StatModel(
        title: 'شركاء الفنادق',
        value: '48',
        changeLabel: '',
        isPositive: true,
        progress: 0.5,
      ),
    ];
  }

  List<HotelBooking> getHotelBookings() {
    return [
      HotelBooking(
        id: 'H-2034',
        hotelName: 'فندق بورتو السخنة',
        stars: 4.5,
        location: 'العين السخنة، مصر',
        checkIn: '2025-06-10',
        checkOut: '2025-06-15',
        guests: 'شخصين',
        roomType: 'جناح',
        price: '580\$',
        status: BookingStatus.confirmed,
        clientName: 'أحمد محمد',
      ),
      HotelBooking(
        id: 'H-4512',
        hotelName: 'فندق جميرا بيتش',
        stars: 5.0,
        location: 'دبي، الإمارات',
        checkIn: '2025-07-01',
        checkOut: '2025-07-07',
        guests: 'عائلة',
        roomType: 'غرفتين',
        price: '2,450\$',
        status: BookingStatus.payment_pending,
        clientName: 'سارة خالد',
      ),
      HotelBooking(
        id: 'H-6723',
        hotelName: 'فندق الفور سيزونز',
        stars: 5.0,
        location: 'القاهرة، مصر',
        checkIn: '2025-05-28',
        checkOut: '2025-05-30',
        guests: 'شخص',
        roomType: 'جناح رئاسي',
        price: '1,120\$',
        status: BookingStatus.confirmed,
        clientName: 'يوسف علي',
      ),
    ];
  }

  List<StatModel> getCarStats() {
    return [
      StatModel(
        title: 'إجمالي حجوزات السيارات',
        value: '156',
        changeLabel: '',
        isPositive: true,
        progress: 1.0,
      ),
      StatModel(
        title: 'إيرادات التأجير',
        value: '87.5k\$',
        changeLabel: '',
        isPositive: true,
        progress: 0.8,
      ),
      StatModel(
        title: 'متوسط مدة الإيجار',
        value: '4.2 يوم',
        changeLabel: '',
        isPositive: true,
        progress: 0.6,
      ),
      StatModel(
        title: 'شركات التأجير',
        value: '23',
        changeLabel: '',
        isPositive: true,
        progress: 0.4,
      ),
    ];
  }

  List<CarBooking> getCarBookings() {
    return [
      CarBooking(
        id: 'C-1024',
        carModel: 'مرسيدس E-Class',
        category: 'فاخرة',
        fuelType: 'بنزين',
        pickupLocation: 'مطار دبي',
        pickupDate: '2025-06-10',
        returnLocation: 'مطار دبي',
        returnDate: '2025-06-15',
        duration: '5 أيام',
        totalPrice: '650\$',
        status: BookingStatus.confirmed,
        clientName: 'خالد العتيبي',
      ),
      CarBooking(
        id: 'C-2108',
        carModel: 'تويوتا لاند كروزر',
        category: 'SUV',
        fuelType: 'بنزين',
        pickupLocation: 'مدينة الكويت',
        pickupDate: '2025-07-01',
        returnLocation: 'مدينة الكويت',
        returnDate: '2025-07-10',
        duration: '9 أيام',
        totalPrice: '1,080\$',
        status: BookingStatus.payment_pending,
        clientName: 'نورة الهاشمي',
      ),
      CarBooking(
        id: 'C-8901',
        carModel: 'بي ام دبليو الفئة السابعة',
        category: 'فاخرة',
        fuelType: 'هجين',
        pickupLocation: 'فندق جميرا',
        pickupDate: '2025-06-20',
        returnLocation: 'مطار دبي',
        returnDate: '2025-06-25',
        duration: '5 أيام',
        totalPrice: '1,650\$',
        status: BookingStatus.confirmed,
        clientName: 'سلمان آل خليفة',
        withDriver: true,
      ),
    ];
  }

  List<StatModel> getUsersStats() {
    return [
      StatModel(
        title: 'إجمالي المستخدمين',
        value: '1,284',
        changeLabel: '',
        isPositive: true,
        progress: 1.0,
      ),
      StatModel(
        title: 'الوكلاء B2B',
        value: '47',
        changeLabel: '',
        isPositive: true,
        progress: 0.3,
      ),
      StatModel(
        title: 'العملاء B2C',
        value: '892',
        changeLabel: '',
        isPositive: true,
        progress: 0.7,
      ),
      StatModel(
        title: 'مستخدمين جدد',
        value: '+124',
        changeLabel: '',
        isPositive: true,
        progress: 0.6,
      ),
    ];
  }

  List<AdminUserModel> getUsers() {
    return [
      AdminUserModel(
        id: '1',
        name: 'أحمد المدير',
        username: 'ahmed',
        email: 'admin@travel.com',
        avatarUrl:
            'https://ui-avatars.com/api/?background=8b5cf6&color=fff&name=Ahmed',
        role: UserRole.admin,
        registrationDate: '2024-01-15',
        bookingCount: 0,
        isActive: true,
      ),
      AdminUserModel(
        id: '2',
        name: 'فيصل القحطاني',
        username: 'faisal',
        email: 'faisal@arabiatravel.com',
        avatarUrl:
            'https://ui-avatars.com/api/?background=ec4899&color=fff&name=Faisal',
        role: UserRole.b2b,
        registrationDate: '2024-03-10',
        bookingCount: 142,
        isActive: true,
        companyName: 'السفر العربية',
      ),
      AdminUserModel(
        id: '3',
        name: 'نورة عبدالله',
        username: 'nora',
        email: 'nora@mastravel.com',
        avatarUrl:
            'https://ui-avatars.com/api/?background=8b5cf6&color=fff&name=Nora',
        role: UserRole.b2b,
        registrationDate: '2024-05-20',
        bookingCount: 98,
        isActive: true,
        companyName: 'ماس للسياحة',
      ),
      AdminUserModel(
        id: '4',
        name: 'محمد علي',
        username: 'mohamed',
        email: 'mohamed@example.com',
        avatarUrl:
            'https://ui-avatars.com/api/?background=10b981&color=fff&name=Mohamed',
        role: UserRole.b2c,
        registrationDate: '2025-02-01',
        bookingCount: 5,
        isActive: true,
      ),
    ];
  }
}
