import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/home/list_view/bloc/listview_bloc.dart';
import 'package:gan2/home/process_menu/bloc/processMenu_bloc.dart';
import 'package:gan2/home/process_tile/bloc/processtile_bloc.dart';
import 'package:gan2/home/process_tile/process_tile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListViewBuilder extends StatefulWidget {
  //TODO switch between list and grid view
  //TODO: popup options menu on long press

  @override
  _ListViewBuilderState createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  ListViewBloc _listViewBloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _listViewBloc.add(RefreshData());
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    //* do stuff
    // setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    _listViewBloc = BlocProvider.of<ListViewBloc>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Scaffold(
        body: BlocConsumer<ListViewBloc, ListViewState>(
          listener: (context, state) {
            print(state);
            if (state is ListViewLoaded) {
              print('listen');
              return true;
            }
            return true;
          },
          builder: (context, state) {
            print('build');
            if (state is ListViewLoaded) {
              if (state.data.isEmpty) {
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('No Data'),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            _listViewBloc.add(RefreshData());
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                  itemCount: state.data.length,
                  reverse: false,
                  itemBuilder: (BuildContext context, int index) {
                    print(index);
                    return Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Container(
                        height: 100,
                        color: Colors.lightBlue[200],
                        child: Center(
                          child: MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => ProcessMenuBloc(),
                              ),
                              BlocProvider(
                                create: (context) => ListViewBloc(),
                              ),
                              BlocProvider(
                                create: (context) => ProcessTileBloc(),
                              )
                            ],
                            child: ProcessTile(
                              data: state.data[index],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return loading();
          },
        ),
      ),
    );
  }

  Widget loading() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Loading'),
          ],
        ),
      ),
    );
  }
}
