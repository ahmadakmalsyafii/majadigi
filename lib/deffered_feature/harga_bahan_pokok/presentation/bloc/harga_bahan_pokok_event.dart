abstract class HargaBahanPokokEvent {}

class FetchCommodityList extends HargaBahanPokokEvent {
  final int page;
  final int limit;
  final String searchQuery;
  FetchCommodityList({this.page = 1, this.limit = 999, this.searchQuery = ''});
}

class FetchCommodityDetail extends HargaBahanPokokEvent {
  final int bpId;
  FetchCommodityDetail(this.bpId);
}
