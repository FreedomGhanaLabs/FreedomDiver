part of 'message_cubit.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {

  const MessageLoaded(this.messages);
  final List<MessageModel> messages;

  @override
  List<Object> get props => [messages];
}

class MessageError extends MessageState {

  const MessageError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
