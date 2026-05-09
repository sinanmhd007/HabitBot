import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitbot/features/auth/domain/repositories/auth_repository.dart';
import 'package:habitbot/features/habits/domain/usecases/accountability_engine.dart';
import 'package:habitbot/features/habits/domain/usecases/add_habit_usecase.dart';
import 'package:habitbot/features/habits/domain/usecases/delete_habit_usecase.dart';
import 'package:habitbot/features/habits/domain/usecases/get_habits_usecase.dart';
import 'package:habitbot/features/habits/domain/usecases/toggle_habit_status_usecase.dart';
import 'package:habitbot/features/habits/domain/usecases/update_habit_usecase.dart';
import 'habit_event.dart';
import 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final GetHabitsUseCase getHabits;
  final AddHabitUseCase addHabit;
  final UpdateHabitUseCase updateHabit;
  final DeleteHabitUseCase deleteHabit;
  final ToggleHabitStatusUseCase toggleHabitStatus;
  final AuthRepository authRepository;
  final AccountabilityEngine accountabilityEngine;

  HabitBloc({
    required this.getHabits,
    required this.addHabit,
    required this.updateHabit,
    required this.deleteHabit,
    required this.toggleHabitStatus,
    required this.authRepository,
    required this.accountabilityEngine,
  }) : super(HabitInitial()) {
    on<LoadHabitsEvent>(_onLoadHabits);
    on<AddHabitEvent>(_onAddHabit);
    on<UpdateHabitEvent>(_onUpdateHabit);
    on<DeleteHabitEvent>(_onDeleteHabit);
    on<ToggleHabitStatusEvent>(_onToggleHabitStatus);
  }

  Future<void> _onLoadHabits(LoadHabitsEvent event, Emitter<HabitState> emit) async {
    emit(HabitLoading());
    final (failure, habits) = await getHabits(event.userId);
    if (failure != null) {
      emit(HabitError(failure.message));
    } else if (habits != null) {
      emit(HabitLoaded(habits));
      
      try {
        final (_, user) = await authRepository.checkAuthStatus();
        if (user != null) {
          await accountabilityEngine.run(user, habits);
        }
      } catch (e) {
        // Log engine errors silently
      }
    } else {
      emit(const HabitError('Unexpected error occurred'));
    }
  }

  Future<void> _onAddHabit(AddHabitEvent event, Emitter<HabitState> emit) async {
    final currentState = state;
    if (currentState is HabitLoaded) {
      final (failure, _) = await addHabit(event.userId, event.habit);
      if (failure != null) {
        emit(HabitError(failure.message));
        emit(currentState);
      } else {
        add(LoadHabitsEvent(event.userId));
      }
    }
  }

  Future<void> _onUpdateHabit(UpdateHabitEvent event, Emitter<HabitState> emit) async {
    final currentState = state;
    if (currentState is HabitLoaded) {
      final (failure, _) = await updateHabit(event.userId, event.habit);
      if (failure != null) {
        emit(HabitError(failure.message));
        emit(currentState);
      } else {
        add(LoadHabitsEvent(event.userId));
      }
    }
  }

  Future<void> _onDeleteHabit(DeleteHabitEvent event, Emitter<HabitState> emit) async {
    final currentState = state;
    if (currentState is HabitLoaded) {
      final (failure, _) = await deleteHabit(event.userId, event.habitId);
      if (failure != null) {
        emit(HabitError(failure.message));
        emit(currentState);
      } else {
        add(LoadHabitsEvent(event.userId));
      }
    }
  }

  Future<void> _onToggleHabitStatus(ToggleHabitStatusEvent event, Emitter<HabitState> emit) async {
    final currentState = state;
    if (currentState is HabitLoaded) {
      // Simple approach: perform remote update then reload.
      final (failure, _) = await toggleHabitStatus(event.userId, event.habit, event.dateStr, event.isCompleted);
      if (failure != null) {
         emit(HabitError(failure.message));
         emit(currentState);
      } else {
         add(LoadHabitsEvent(event.userId));
      }
    }
  }
}
