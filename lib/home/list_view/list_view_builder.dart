import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/home/list_view/bloc/listview_bloc.dart';
// import 'package:gan2/home/process_menu/bloc/processMenu_bloc.dart';
import 'package:gan2/home/process_tile/bloc/processtile_bloc.dart';
import 'package:gan2/home/process_tile/process_tile.dart';

class ListViewBuilder extends StatefulWidget {
  //TODO switch between list and grid view
  final double textScale;

  const ListViewBuilder({Key key, @required this.textScale}) : super(key: key);

  @override
  _ListViewBuilderState createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  ListViewBuilderBloc _listViewBloc;

  Future<void> onRefresh() async {
    _listViewBloc.add(RefreshData());
  }

  @override
  Widget build(BuildContext context) {
    _listViewBloc = BlocProvider.of<ListViewBuilderBloc>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Scaffold(
        body: BlocBuilder<ListViewBuilderBloc, ListViewBuilderState>(
          builder: (context, state) {
            print('build');
            if (state is ListViewBuilderLoaded) {
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
              } else {
                return RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  onRefresh: onRefresh,
                  child: ListView.builder(
                    reverse: false,
                    itemCount: state.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Container(
                          height: 100,
                          // color: Theme.of(context).accentColor,
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: BlocProvider(
                                  create: (context) => ProcessTileBloc(),
                                  child: ProcessTile(
                                    data: state.data[index],
                                    textScale: widget.textScale,
                                    key:
                                        ValueKey(state.data[index].processName),
                                  ),
                                ),
                              ),
                              Divider(
                                indent: 16,
                                endIndent: 16,
                                color: Colors.grey[200],
                                thickness: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
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
            CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 10),
            Text('Loading'),
          ],
        ),
      ),
    );
  }
}
