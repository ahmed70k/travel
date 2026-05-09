import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/neon_text.dart';
import '../cubit/car_bookings_cubit.dart';
import '../cubit/car_bookings_state.dart';
import '../widgets/car_booking_card.dart';
import '../widgets/detailed_car_table.dart';
import 'create_car_booking_page.dart';

class AdminCarBookingsPage extends StatelessWidget {
  const AdminCarBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CarBookingsCubit>()..fetchBookings(refresh: true),
      child: const AdminCarBookingsView(),
    );
  }
}

class AdminCarBookingsView extends StatefulWidget {
  const AdminCarBookingsView({super.key});

  @override
  State<AdminCarBookingsView> createState() => _AdminCarBookingsViewState();
}

class _AdminCarBookingsViewState extends State<AdminCarBookingsView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CarBookingsCubit>().fetchBookings();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<CarBookingsCubit, CarBookingsState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async => context.read<CarBookingsCubit>().fetchBookings(refresh: true),
            color: AppColors.primary,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isMobile),
                  const SizedBox(height: 32),
                  _buildFilters(context, state, isMobile),
                  const SizedBox(height: 24),
                  if (state is CarBookingsLoading)
                    _buildSkeletonLoader(isMobile)
                  else if (state is CarBookingsError)
                    _buildError(state.message, () => context.read<CarBookingsCubit>().fetchBookings(refresh: true))
                  else if (state is CarBookingsLoaded || state is CarBookingsLoadingMore)
                    _buildContent(context, state, isMobile)
                  else
                    const SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'الإدارة / الحجوزات',
              style: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 2),
            ),
            const SizedBox(height: 8),
            NeonText(
              'تأجير السيارات',
              style: TextStyle(fontSize: isMobile ? 32 : 44, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateCarBookingPage()),
            );
          },
          icon: const Icon(Icons.add, size: 20),
          label: Text(isMobile ? 'إضافة' : 'إضافة حجز'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 20,
              vertical: isMobile ? 10 : 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context, CarBookingsState state, bool isMobile) {
    String currentStatus = 'all';
    if (state is CarBookingsLoaded) {
      currentStatus = state.status ?? 'all';
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: isMobile ? double.infinity : 300,
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'البحث عن سيارة أو مدينة...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 22),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white60, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        context.read<CarBookingsCubit>().updateSearch('');
                        setState(() {});
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (val) {
              if (val.isEmpty) {
                context.read<CarBookingsCubit>().updateSearch('');
              }
              setState(() {});
            },
            onSubmitted: (val) => context.read<CarBookingsCubit>().updateSearch(val),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentStatus,
              dropdownColor: const Color(0xFF1E293B),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              items: [
                {'val': 'all', 'label': 'الكل'},
                {'val': 'confirmed', 'label': 'مؤكد'},
                {'val': 'pending', 'label': 'معلق'},
                {'val': 'cancelled', 'label': 'ملغي'},
                {'val': 'refunded', 'label': 'مسترجع'},
              ]
                  .map((s) => DropdownMenuItem(
                        value: s['val'],
                        child: Text(s['label'] as String),
                      ))
                  .toList(),
              onChanged: (val) => context.read<CarBookingsCubit>().updateStatus(val),
            ),
          ),
        ),
        if (state is CarBookingsLoaded)
          IconButton(
            onPressed: () => context.read<CarBookingsCubit>().toggleSortOrder(),
            icon: Icon(
              state.sortOrder == 'desc' ? Icons.south : Icons.north,
              color: AppColors.primary,
            ),
            tooltip: 'ترتيب حسب تاريخ الاستلام',
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, CarBookingsState state, bool isMobile) {
    final bookings = (state as dynamic).bookings;
    final isLoadingMore = state is CarBookingsLoadingMore;

    if (bookings.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        if (isMobile)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bookings.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) => CarBookingCard(booking: bookings[index]),
          )
        else
          DetailedCarTable(bookings: bookings),
        
        if (isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          ),
        
        if (state is CarBookingsLoaded && state.hasReachedMax && bookings.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                'عرض ${bookings.length} من أصل ${state.totalCount} حجز',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSkeletonLoader(bool isMobile) {
    return Column(
      children: List.generate(5, (index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: isMobile ? 120 : 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      )),
    );
  }

  Widget _buildError(String message, VoidCallback onRetry) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          Icon(Icons.directions_car_outlined, color: Colors.white.withOpacity(0.1), size: 100),
          const SizedBox(height: 24),
          const Text(
            'لم يتم العثور على حجوزات سيارات',
            style: TextStyle(color: AppColors.textMuted, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

