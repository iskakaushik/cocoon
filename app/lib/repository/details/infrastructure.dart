// Copyright (c) 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_web/material.dart';

import '../models/build_status.dart';
import '../models/github_status.dart';
import '../models/providers.dart';

class InfrastructureDetails extends StatelessWidget {
  const InfrastructureDetails();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          const ModelBinding<BuildStatus>(
            initialModel: BuildStatus(),
            child: _BuildStatusWidget()
          ),
          ModelBinding<GithubStatus>(
            initialModel: const GithubStatus(),
            child: ListTile(
              leading: CircleAvatar(
                child: Image.network('https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png'),
              ),
              title: const Text('Github'),
              trailing: const _GithubStatusIndicator(),
            ),
          ),
        ]
      ),
    );
  }
}

class _GithubStatusIndicator extends StatelessWidget {
  const _GithubStatusIndicator();

  @override
  Widget build(BuildContext context) {
    final GithubStatus githubStatus = ModelBinding.of<GithubStatus>(context);
    IconData icon;
    Color backgroundColor;
    switch (githubStatus.indicator) {
      case 'none':
        icon = Icons.check;
        backgroundColor = Colors.greenAccent;
        break;
      case 'minor':
        icon = Icons.warning;
        backgroundColor = Colors.amberAccent;
        break;
      case 'major':
        icon = Icons.error;
        backgroundColor = Colors.orangeAccent;
        break;
      case 'critical':
        icon = Icons.error;
        backgroundColor = Colors.redAccent;
        break;
      default:
        icon = Icons.help_outline;
        backgroundColor = Colors.grey;
    }
    return Semantics(
      child: RefreshGithubStatus(
        child: Chip(
          avatar: Icon(icon, size: 18.0),
          backgroundColor: backgroundColor,
          labelPadding: const EdgeInsets.fromLTRB(3.0, 3.0, 8.0, 3.0),
          label: Text(githubStatus.status ?? 'Unknown')
        ),
      ),
      hint: 'Github Status',
    );
  }
}

class _BuildStatusWidget extends StatelessWidget {
  const _BuildStatusWidget();

  @override
  Widget build(BuildContext context) {
    final BuildStatus status = ModelBinding.of<BuildStatus>(context);

    return RefreshBuildStatus(
      child: Column(
        children: <Widget>[
          _buildStatusWidget(status),
          if (status.failingAgents.isNotEmpty)
            const Divider(),
          for (String agent in status.failingAgents)
            _failingAgentWidget(agent),
          if (status.failingAgents.isNotEmpty)
            const Divider(),
        ]
      )
    );
  }

  Widget _buildStatusWidget(BuildStatus status) {
    IconData icon;
    Color backgroundColor;
    switch (status.anticipatedBuildStatus) {
      case 'Succeeded':
        icon = Icons.check;
        backgroundColor = Colors.greenAccent;
        break;
      case 'Build Will Fail':
        icon = Icons.error;
        backgroundColor = Colors.redAccent;
        break;
      default:
        icon = Icons.help_outline;
        backgroundColor = Colors.grey;
    }

    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.devices),
      ),
      title: const Text('Last Flutter Commit'),
      trailing: Semantics(
        child: Chip(
          avatar: Icon(icon, size: 18.0),
          backgroundColor: backgroundColor,
          labelPadding: const EdgeInsets.fromLTRB(3.0, 3.0, 8.0, 3.0),
          label: Text(status.anticipatedBuildStatus ?? 'Unknown')
        ),
        hint: 'Build Status',
      ),
    );
  }

  Widget _failingAgentWidget(String agentName) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.desktop_windows),
        foregroundColor: Colors.white,
        backgroundColor: Colors.redAccent,
      ),
      title: Text('$agentName Unhealthy')
    );
  }
}