import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_workouts/data/services/time_panel_service.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/time_panel/countdown/countdown_tab.dart';
import 'package:track_workouts/routes/new_workout/new_workout_details/time_panel/timer/timer.dart';
import 'package:track_workouts/style/theme.dart';
import 'package:track_workouts/ui_elements/panel.dart';
import 'package:track_workouts/ui_elements/panel_header.dart';

class TimePanelWrapper extends StatelessWidget {
  final Widget child;
  final double panelHeight;
  final double borderRadius;

  const TimePanelWrapper({
    @required this.child,
    this.panelHeight = 52.0,
    this.borderRadius = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<TimePanelService>(context);
    return SlidingUpPanel(
      controller: service.panelController,
      color: AppColors.black950,
      minHeight: panelHeight,
      parallaxEnabled: true,
      backdropTapClosesPanel: true,
      backdropEnabled: true,
      borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
      header: PanelHeader(),
      body: Padding(
        padding: EdgeInsets.only(bottom: panelHeight - borderRadius),
        child: child,
      ),
      panel: TimePanel(),
    );
  }
}

class TimePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          SizedBox(height: 64.0),
          Expanded(
            child: TabBarView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 52.0),
                  child: CountdownTab(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 52.0),
                  child: Timer(),
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.primary,
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.timelapse)),
                Tab(icon: Icon(Icons.timer)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
