import '../database.dart';

class InvestmentOpportunitiesTable extends SupabaseTable<InvestmentOpportunitiesRow> {
  @override
  String get tableName => 'investmentOpportunities';

  @override
  InvestmentOpportunitiesRow createRow(Map<String, dynamic> data) =>
      InvestmentOpportunitiesRow(data);
}

class InvestmentOpportunitiesRow extends SupabaseDataRow {
  InvestmentOpportunitiesRow(super.data);

  @override
  SupabaseTable get table => InvestmentOpportunitiesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get sector => getField<String>('sector');
  set sector(String? value) => setField<String>('sector', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get website => getField<String>('website');
  set website(String? value) => setField<String>('website', value);
}