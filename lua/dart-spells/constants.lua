local M = {}

M.bloc_builder = "BlocBuilder<>(builder:(context,state)"

M.bloc_consumer = "BlocConsumer<>(listener:(context,state){},builder:(context,state)"

M.bloc_listener = "BlocListener<>(listener:(context,state){},"

M.bloc_provider = "BlocProvider<>(create: (context) => ,"

M.multi_bloc_provider = "MultiBlocProvider(providers: const [],"

M.widget_kind = "refactor.flutter.wrap.generic"

M.builder_kind = "refactor.flutter.wrap.builder"

return M
