import 'package:path/path.dart';
import 'package:pmjay/models/masterModel/master.model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'pmjay.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE beneficiaries(
        beneficiaryId INTEGER PRIMARY KEY,
        encryptedBeneficiaryId TEXT,
        syncStatus TEXT,
        syncDate TEXT,
        pmjayId TEXT,
        applicantName TEXT,
        aadhaarNo TEXT,
        mobileNumber TEXT,
        gender TEXT,
        dateOfBirth TEXT,
        address TEXT,
        district TEXT,
        blockName TEXT,
        gramPanchayat TEXT,
        ward TEXT,
        rationCardNo TEXT,
        familyHeadName TEXT,
        familyMembersCount INTEGER,
        familyId TEXT,
        
        
  familyIncomeExclusion TEXT DEFAULT '',
  incomeTaxExclusion TEXT DEFAULT '',
  sirAdjudicationExclusion TEXT DEFAULT '',
  caaApplicationExclusion TEXT DEFAULT '',
  asddListExclusion TEXT DEFAULT ''
      )
    ''');
  }

  Future<void> insertBeneficiaries(List<Beneficiary> beneficiaries) async {
    final db = await database;

    Batch batch = db.batch();

    for (var beneficiary in beneficiaries) {
      batch.insert(
        'beneficiaries',
        beneficiary.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true, continueOnError: true);
  }

  Future<List<Beneficiary>> getBeneficiaries() async {
    final db = await database;

    final result = await db.query(
      'beneficiaries',
      orderBy: 'applicantName ASC',
    );

    return result.map((e) => Beneficiary.fromJson(e)).toList();
  }

  Future<List<Beneficiary>> searchBeneficiaries(String keyword) async {
    final db = await database;

    final result = await db.query(
      'beneficiaries',
      where: '''
      applicantName LIKE ?
      OR pmjayId LIKE ?
      OR aadhaarNo LIKE ?
      OR familyId LIKE ?
    ''',
      whereArgs: ['%$keyword%', '%$keyword%', '%$keyword%', '%$keyword%'],
    );

    return result.map((e) => Beneficiary.fromJson(e)).toList();
  }

  Future<Beneficiary?> getBeneficiary(String aadhaarNo) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      'beneficiaries',
      where: 'aadhaarNo = ?',
      whereArgs: [aadhaarNo],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Beneficiary.fromJson(result.first);
    }

    return null;
  }

  Future<void> updateExclusionCriteria(
    String aadhaarNo,
    String syncStatus,
    String syncDate,
    Map<String, String> answers,
  ) async {
    final db = await database;

    await db.update(
      'beneficiaries',
      {
        'familyIncomeExclusion':
            answers['Family Income > 8 lakh per year'] ?? '',
        'incomeTaxExclusion': answers['Any member paying Income Tax'] ?? '',
        'sirAdjudicationExclusion':
            answers['Pending under SIR Adjudication'] ?? '',
        'caaApplicationExclusion': answers['Pending CAA Application'] ?? '',
        'asddListExclusion': answers['Found in ASDD List'] ?? '',

        // Sync fields
        'syncStatus': syncStatus,
        'syncDate': syncDate,
      },
      where: 'aadhaarNo = ?',
      whereArgs: [aadhaarNo],
    );
  }
}
