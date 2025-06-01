import '../database.dart';

class SocialandculturalfactorsTable
    extends SupabaseTable<SocialandculturalfactorsRow> {
  @override
  String get tableName => 'socialandculturalfactors';

  @override
  SocialandculturalfactorsRow createRow(Map<String, dynamic> data) =>
      SocialandculturalfactorsRow(data);
}

class SocialandculturalfactorsRow extends SupabaseDataRow {
  SocialandculturalfactorsRow(super.data);

  @override
  SupabaseTable get table => SocialandculturalfactorsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get educationandworkforcequality =>
      getField<String>('educationandworkforcequality');
  set educationandworkforcequality(String? value) =>
      setField<String>('educationandworkforcequality', value);

  String? get livingstandard => getField<String>('livingstandard');
  set livingstandard(String? value) =>
      setField<String>('livingstandard', value);

  String? get culturalnorms => getField<String>('culturalnorms');
  set culturalnorms(String? value) => setField<String>('culturalnorms', value);

  String? get languageProficiency => getField<String>('language_proficiency');
  set languageProficiency(String? value) =>
      setField<String>('language_proficiency', value);
}
