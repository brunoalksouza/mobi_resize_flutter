import 'acesso.dart';

class AcessoPlataformaPlus implements Acesso {
  @override
  final bool acesso;
  final PlatformGalleryAccess galleryAccess;
  final PlatformMenuAccess menuAccess;
  final PlatformBranchAccess branchAccess;
  final PlatformDeviceAccess deviceAccess;
  final PlatformConfigurationAccess configurationAccess;
  final PlatformAdvertisingAccess advertisingAccess;
  final PlatformReportAccess reportAccess;
  final PlatformPlaylistAccess playlistAccess;
  final PlatformSchedulerAccess schedulerAccess;
  final bool canLockMedia;
  final bool canRestartService;

  const AcessoPlataformaPlus({
    this.acesso = false,
    this.galleryAccess = const PlatformGalleryAccess(),
    this.menuAccess = const PlatformMenuAccess(),
    this.branchAccess = const PlatformBranchAccess(),
    this.deviceAccess = const PlatformDeviceAccess(),
    this.configurationAccess = const PlatformConfigurationAccess(),
    this.advertisingAccess = const PlatformAdvertisingAccess(),
    this.reportAccess = const PlatformReportAccess(),
    this.playlistAccess = const PlatformPlaylistAccess(),
    this.schedulerAccess = const PlatformSchedulerAccess(),
    this.canLockMedia = false,
    this.canRestartService = false,
  });

  factory AcessoPlataformaPlus.fromMap(Map<String, dynamic> map) {
    return AcessoPlataformaPlus(
      acesso: map['acesso'] ?? false,
      galleryAccess: map['galleryAccess'] == null
          ? PlatformGalleryAccess(
              canUpload: true,
              canEdit: true,
              canMove: true,
              canDelete: true,
            )
          : PlatformGalleryAccess.fromJson(map['galleryAccess']),
      menuAccess: map['menuAccess'] == null
          ? PlatformMenuAccess()
          : PlatformMenuAccess.fromJson(map['menuAccess']),
      branchAccess: map['branchAccess'] == null
          ? PlatformBranchAccess()
          : PlatformBranchAccess.fromJson(map['branchAccess']),
      deviceAccess: map['deviceAccess'] == null
          ? PlatformDeviceAccess()
          : PlatformDeviceAccess.fromJson(map['deviceAccess']),
      configurationAccess: map['configurationAccess'] == null
          ? PlatformConfigurationAccess()
          : PlatformConfigurationAccess.fromJson(map['configurationAccess']),
      advertisingAccess: map['advertisingAccess'] == null
          ? PlatformAdvertisingAccess()
          : PlatformAdvertisingAccess.fromJson(map['advertisingAccess']),
      reportAccess: map['reportAccess'] == null
          ? PlatformReportAccess()
          : PlatformReportAccess.fromJson(map['reportAccess']),
      playlistAccess: map['playlistAccess'] == null
          ? PlatformPlaylistAccess()
          : PlatformPlaylistAccess.fromJson(map['playlistAccess']),
      schedulerAccess: map['schedulerAccess'] == null
          ? PlatformSchedulerAccess()
          : PlatformSchedulerAccess.fromJson(map['schedulerAccess']),
      canLockMedia: map['canLockMedia'] ?? false,
      canRestartService: map['canRestartService'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'acesso': this.acesso,
        'galleryAccess': this.galleryAccess.toJson(),
        'menuAccess': this.menuAccess.toJson(),
        'branchAccess': this.branchAccess.toJson(),
        'deviceAccess': this.deviceAccess.toJson(),
        'configurationAccess': this.configurationAccess.toJson(),
        'advertisingAccess': this.advertisingAccess.toJson(),
        'reportAccess': this.reportAccess.toJson(),
        'playlistAccess': this.playlistAccess.toJson(),
        'schedulerAccess': this.schedulerAccess.toJson(),
        'canLockMedia': this.canLockMedia,
        'canRestartService': this.canRestartService,
      };
}

class PlatformBranchAccess {
  final bool canManage;
  final bool canCreate;
  final bool canDelete;

  const PlatformBranchAccess({
    this.canManage = true,
    this.canCreate = true,
    this.canDelete = true,
  });

  factory PlatformBranchAccess.fromJson(Map<String, dynamic> json) {
    return PlatformBranchAccess(
        canManage: json['canManage'] ?? true,
        canCreate: json['canCreate'] ?? true,
        canDelete: json['canDelete'] ?? true);
  }

  Map<String, dynamic> toJson() {
    return {
      'canManage': this.canManage,
      'canCreate': this.canCreate,
      'canDelete': this.canDelete,
    };
  }
}

class PlatformDeviceAccess {
  final bool canEdit;
  final bool canDelete;
  final bool canManage;

  const PlatformDeviceAccess({
    this.canEdit = true,
    this.canDelete = false,
    this.canManage = true,
  });

  factory PlatformDeviceAccess.fromJson(Map<String, dynamic> json) {
    return PlatformDeviceAccess(
      canEdit: json['canEdit'] ?? true,
      canDelete: json['canDelete'] ?? false,
      canManage: json['canManage'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canEdit': this.canEdit,
      'canDelete': this.canDelete,
      'canManage': this.canManage,
    };
  }
}

class PlatformConfigurationAccess {
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;

  const PlatformConfigurationAccess({
    this.canCreate = true,
    this.canDelete = true,
    this.canEdit = true,
  });

  factory PlatformConfigurationAccess.fromJson(Map<String, dynamic> json) {
    return PlatformConfigurationAccess(
      canCreate: json['canCreate'] ?? true,
      canDelete: json['canDelete'] ?? true,
      canEdit: json['canEdit'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canCreate': this.canCreate,
      'canDelete': this.canDelete,
      'canEdit': this.canEdit,
    };
  }
}

class PlatformAdvertisingAccess {
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;

  const PlatformAdvertisingAccess({
    this.canCreate = true,
    this.canEdit = true,
    this.canDelete = true,
  });

  factory PlatformAdvertisingAccess.fromJson(Map<String, dynamic> json) {
    return PlatformAdvertisingAccess(
      canCreate: json['canCreate'] ?? true,
      canEdit: json['canEdit'] ?? true,
      canDelete: json['canDelete'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canCreate': this.canCreate,
      'canEdit': this.canEdit,
      'canDelete': this.canDelete,
    };
  }
}

class PlatformReportAccess {
  final bool canExport;
  final bool canDownload;
  final bool canDelete;

  const PlatformReportAccess({
    this.canExport = true,
    this.canDownload = true,
    this.canDelete = true,
  });

  factory PlatformReportAccess.fromJson(Map<String, dynamic> json) {
    return PlatformReportAccess(
      canExport: json['canExport'] ?? true,
      canDownload: json['canDownload'] ?? true,
      canDelete: json['canDelete'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canExport': this.canExport,
      'canDownload': this.canDownload,
      'canDelete': this.canDelete,
    };
  }
}

class PlatformPlaylistAccess {
  final bool canCreate;
  final bool canSendToDevice;
  final bool canManage;
  final bool canDelete;
  final bool canCopy;
  final bool canInsertMedia;
  final bool canDeleteMedia;
  final bool canEditMedia;
  final bool canCopyMedia;
  final bool hasGalleryAccess;
  final bool hasNewsAccess;
  final bool hasWeatherAccess;
  final bool hasTableAccess;
  final bool hasWebviewAccess;
  final bool hasPlaylistAccess;
  final bool hasAdvertisingAccess;
  final List<MediaTypeAccess> mediasTypes;

  const PlatformPlaylistAccess({
    this.canCreate = true,
    this.canSendToDevice = true,
    this.canManage = true,
    this.canDelete = true,
    this.canCopy = true,
    this.canInsertMedia = true,
    this.canDeleteMedia = true,
    this.canEditMedia = true,
    this.canCopyMedia = true,
    this.hasGalleryAccess = true,
    this.hasNewsAccess = false,
    this.hasWeatherAccess = true,
    this.hasTableAccess = true,
    this.hasWebviewAccess = true,
    this.hasPlaylistAccess = false,
    this.hasAdvertisingAccess = false,
    this.mediasTypes = MediaTypeAccess.values,
  });

  factory PlatformPlaylistAccess.fromJson(Map<String, dynamic> json) {
    return PlatformPlaylistAccess(
        canCreate: json['canCreate'] ?? true,
        canSendToDevice: json['canSendToDevice'] ?? true,
        canManage: json['canManage'] ?? true,
        canDelete: json['canDelete'] ?? true,
        canCopy: json['canCopy'] ?? true,
        canInsertMedia: json['canInsertMedia'] ?? true,
        canDeleteMedia: json['canDeleteMedia'] ?? true,
        canEditMedia: json['canEditMedia'] ?? true,
        canCopyMedia: json['canCopyMedia'] ?? true,
        hasGalleryAccess: json['hasGalleryAccess'] ?? true,
        hasNewsAccess: json['hasNewsAccess'] ?? false,
        hasWeatherAccess: json['hasWeatherAccess'] ?? true,
        hasTableAccess: json['hasTableAccess'] ?? true,
        hasWebviewAccess: json['hasWebviewAccess'] ?? true,
        hasPlaylistAccess: json['hasPlaylistAccess'] ?? false,
        hasAdvertisingAccess: json['hasAdvertisingAccess'] ?? false,
        mediasTypes: json['mediasTypes'] == null
            ? MediaTypeAccess.values
            : List<String>.from(json['mediasTypes'])
                .map((type) =>
                    MediaTypeAccess.values.firstWhere((e) => e.name == type))
                .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'canCreate': this.canCreate,
      'canSendToDevice': this.canSendToDevice,
      'canManage': this.canManage,
      'canDelete': this.canDelete,
      'canCopy': this.canCopy,
      'canInsertMedia': this.canInsertMedia,
      'canDeleteMedia': this.canDeleteMedia,
      'canEditMedia': this.canEditMedia,
      'canCopyMedia': this.canCopyMedia,
      'hasGalleryAccess': this.hasGalleryAccess,
      'hasNewsAccess': this.hasNewsAccess,
      'hasWeatherAccess': this.hasWeatherAccess,
      'hasTableAccess': this.hasTableAccess,
      'hasWebviewAccess': this.hasWebviewAccess,
      'hasPlaylistAccess': this.hasPlaylistAccess,
      'hasAdvertisingAccess': this.hasAdvertisingAccess,
      'mediasTypes': this.mediasTypes.map((e) => e.name).toList(),
    };
  }
}

class PlatformGalleryAccess {
  final bool canUpload;
  final bool canDelete;
  final bool canMove;
  final bool canEdit;

  const PlatformGalleryAccess({
    this.canUpload = true,
    this.canDelete = true,
    this.canMove = true,
    this.canEdit = true,
  });

  factory PlatformGalleryAccess.fromJson(Map<String, dynamic> json) {
    return PlatformGalleryAccess(
      canUpload: json['canUpload'] ?? true,
      canDelete: json['canDelete'] ?? true,
      canMove: json['canMove'] ?? true,
      canEdit: json['canEdit'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canUpload': canUpload,
      'canDelete': canDelete,
      'canMove': canMove,
      'canEdit': canEdit,
    };
  }
}

class PlatformMenuAccess {
  final bool canAccessDashboard;
  final bool canAccessBranches;
  final bool canAccessConfigurations;
  final bool canAccessDevices;
  final bool canAccessGallery;
  final bool canAccessAdvertising;
  final bool canAccessReports;
  final bool canAccessPlaylists;
  final bool canAccessPlaylistScheduler;

  const PlatformMenuAccess({
    this.canAccessDashboard = true,
    this.canAccessBranches = true,
    this.canAccessConfigurations = true,
    this.canAccessDevices = true,
    this.canAccessGallery = true,
    this.canAccessAdvertising = false,
    this.canAccessReports = false,
    this.canAccessPlaylists = true,
    this.canAccessPlaylistScheduler = false,
  });

  factory PlatformMenuAccess.fromJson(Map<String, dynamic> json) {
    return PlatformMenuAccess(
      canAccessDashboard: json['canAccessDashboard'] ?? true,
      canAccessBranches: json['canAccessBranches'] ?? true,
      canAccessConfigurations: json['canAccessConfigurations'] ?? true,
      canAccessDevices: json['canAccessDevices'] ?? true,
      canAccessGallery: json['canAccessGallery'] ?? true,
      canAccessAdvertising: json['canAccessAdvertising'] ?? false,
      canAccessReports: json['canAccessReports'] ?? false,
      canAccessPlaylists: json['canAccessPlaylists'] ?? true,
      canAccessPlaylistScheduler: json['canAccessPlaylistScheduler'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canAccessDashboard': canAccessDashboard,
      'canAccessBranches': canAccessBranches,
      'canAccessConfigurations': canAccessConfigurations,
      'canAccessDevices': canAccessDevices,
      'canAccessGallery': canAccessGallery,
      'canAccessAdvertising': canAccessAdvertising,
      'canAccessReports': canAccessReports,
      'canAccessPlaylists': canAccessPlaylists,
      'canAccessPlaylistScheduler': canAccessPlaylistScheduler,
    };
  }
}

class PlatformSchedulerAccess {
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;
  final bool canSendToDevice;

  const PlatformSchedulerAccess({
    this.canCreate = false,
    this.canEdit = false,
    this.canDelete = false,
    this.canSendToDevice = false,
  });

  factory PlatformSchedulerAccess.fromJson(Map<String, dynamic> json) {
    return PlatformSchedulerAccess(
      canCreate: json['canCreate'] ?? false,
      canEdit: json['canEdit'] ?? false,
      canDelete: json['canDelete'] ?? false,
      canSendToDevice: json['canSendToDevice'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canCreate': this.canCreate,
      'canEdit': this.canEdit,
      'canDelete': this.canDelete,
      'canSendToDevice': this.canSendToDevice,
    };
  }
}

enum MediaTypeAccess {
  gallery('Galeria'),
  news('Notícias'),
  weather('Clima'),
  table('Tabela'),
  webview('WebView'),
  advertising('Campanha');

  final String description;

  const MediaTypeAccess(String this.description);
}
