part of 'language_cubit.dart';

sealed class LanguageState extends Equatable {
  const LanguageState();
  
  @override
  List<Object?> get props => [];
}

final class LanguageInitial extends LanguageState {
  const LanguageInitial();
}

final class LanguageSelected extends LanguageState {
  const LanguageSelected(this.locale, {this.isSystem = false});
  final Locale locale;
  final bool isSystem;

  @override
  List<Object?> get props => [locale, isSystem];
}
