import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_cubit.dart';

import '../../utilities/hive/messaging.dart';
import 'models/message.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageLoading());

  Future<void> loadMessages() async {
    emit(MessageLoading());
    try {
      final jsonString = await getMessagesFromHive();
      if (jsonString == null) {
        emit(MessageLoaded([]));
      } else {
        final messages = MessageModel.fromJsonList(jsonString);
        emit(MessageLoaded(messages));
      }
    } catch (e) {
      emit(MessageError('Failed to load messages: $e'));
    }
  }

  Future<void> sendMessage(BuildContext context, MessageModel message, {bool isSocketMessage= false}) async {
    try {
      final currentMessages =
          state is MessageLoaded
              ? List<MessageModel>.from((state as MessageLoaded).messages)
              : <MessageModel>[];

      currentMessages.add(message);
      final jsonString = MessageModel.toJsonList(currentMessages);
      await addMessagesToHive(jsonString);
      emit(MessageLoaded(currentMessages));
    if(!isSocketMessage)  context.read<RideCubit>().sendUserMessage(context, message: message.content);
    } catch (e) {
      emit(MessageError('Failed to send message: $e'));
    }
  }

  Future<void> clearMessages() async {
    try {
      await deleteMessagesFromHive();
      emit(MessageLoaded([]));
    } catch (e) {
      emit(MessageError('Failed to delete messages: $e'));
    }
  }
}
