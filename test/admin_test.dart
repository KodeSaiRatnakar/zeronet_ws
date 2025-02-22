import 'package:flutter_test/flutter_test.dart';
import 'package:zeronet_ws/constants.dart';
import 'package:zeronet_ws/models/models.dart';
import 'package:zeronet_ws/zeronet_ws.dart';

void main() {
  var dashboard = '1HELLoE3sFD9569CLCbHEAVqvqV7U2Ri9d';
  var talk = '1TaLkFrMwvbNsooF4ioKAY9EuxTBTjipT';
  var testSite = '1DCN2A5VqYrQSNds7Y3s9JLn65CfykPKJw';

  var instance = ZeroNet.instance;
  test('Admin::as', () async {
    await instance.connect(dashboard);
    final res = await instance.asFuture(site: talk, cmd: ZeroNetCmd.siteInfo);
    assert(res.isMsg);

    final result2 = await instance.asFuture(
        site: talk, cmd: ZeroNetCmd.dirList, arguments: ['data/users/', false]);

    assert(result2.message!.result is List);
  });

  test('Admin::permissionAdd', () async {
    assert(false);

    /// TODO for non admin sites
    await instance.connect(dashboard);
    final res = await instance.permissionAddFuture('ADMIN');
    assert(res.result == 'ok');
  });

  test('Admin::permissionRemove', () async {
    await instance.connect(dashboard);
    final res = await instance.permissionRemoveFuture('ADMIN');
    assert(res.result == 'ok');
  });

  test('Admin::permissionDetails', () async {
    await instance.connect(dashboard);
    final res = await instance.permissionDetailsFuture('ADMIN');
    assert(res.result is String);
  });

  test('Admin::certList', () async {
    await instance.connect(dashboard);
    final res = await instance.certListFuture();
    assert(res?.result is List);
    if (res?.result is List && res?.result.isNotEmpty) {
      assert(res?.result.first is Map);
    }
  });

  test('Admin::certSet', () async {
    await instance.connect(dashboard);
    final res = await instance.certSetFuture('zeroid.bit');
    assert(res.result == 'ok');
  });

  test('Admin::channelJoinAllsite', () async {
    await instance.connect(dashboard);
    var res = await instance.channelJoinAllSiteFuture('siteChanged');
    assert(res.result is String);
    assert(res.result == 'ok');
  });

  test('Admin::serverConfigSet', () async {
    await instance.connect(dashboard);
    var res = await instance.configSetFuture('open_browser', 'False');
    assert(res.isMsg);
    assert(res.message!.result == 'ok');
    res = await instance.configSetFuture('open_browser', 'default_browser');
    assert(res.isMsg);
    assert(res.message!.result == 'ok');
  });

  test('Admin::serverPortCheck', () async {
    await instance.connect(dashboard);
    var res = await instance.serverPortcheckFuture();
    assert(res?.ipv4 is bool || res?.ipv4 == null);
    assert(res?.ipv6 is bool || res?.ipv6 == null);
  });

  test('Admin::serverRestart', () async {
    await instance.connect(dashboard);
    var res = await instance.serverShutdownFuture(restart: true);
    assert(res?.type == PromptType.confirm);
    assert(res?.value.params[1] == 'Restart');
  });

  test('Admin::serverShutdown', () async {
    await instance.connect(dashboard);
    var res = await instance.serverShutdownFuture();
    assert(res?.type == PromptType.confirm);
    assert(res?.value.params[1] == 'Shut down');
  });
  test('Admin::serverUpdate', () async {
    await instance.connect(dashboard);
    var res = await instance.serverUpdateFuture();
    assert(res?.type == PromptType.confirm);
  });

  test('Admin::siteCloneWithFakeSite', () async {
    await instance.connect(dashboard);
    var res = await instance.siteCloneFuture('FAKE SITE', '');
    assert(res.isErr);
    assert(res.error!.error == 'Not a site: FAKE SITE');
  });

  test('Admin::siteCloneWithAdminSite', () async {
    await instance.connect(dashboard);
    var res = await instance.siteCloneFuture(dashboard, 'template-new');
    assert(res.isMsg);
    assert(res.message!.result is Map);
    assert(res.message!.result['address'] is String);
  });

  test('Admin::siteCloneWithNonAdminSite', () async {
    await instance.connect(talk);
    var res = await instance.siteCloneFuture(dashboard, '');
    assert(res.isPrompt);
    assert(res.prompt!.type == PromptType.confirm);
    assert(res.prompt!.value.params[1] is String);
    assert(res.prompt!.value.params[1] == 'Clone');
  });

  test('Admin::siteList', () async {
    await instance.connect(dashboard);
    var res = await instance.siteListFuture();
    assert(res.isNotEmpty);
  });

  test('Admin::sitePause', () async {
    await instance.connect(dashboard);
    var res = await instance.sitePauseFuture(talk);
    assert(res.isMsg);
    assert(res.message!.result == 'Paused');
  });

  test('Admin::siteResume', () async {
    await instance.connect(dashboard);
    var res = await instance.siteResumeFuture(talk);
    assert(res.isMsg);
    assert(res.message!.result == 'Resumed');
  });
}
