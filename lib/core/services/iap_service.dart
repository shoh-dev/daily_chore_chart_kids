import 'dart:async';
import 'package:daily_chore_chart_kids/core/providers/premium_provider.dart';
import 'package:daily_chore_chart_kids/utils/hive_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:hive/hive.dart';

class IAPService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static const String premiumId = 'premium_unlock'; // Product ID from store
  static final Set<String> _productIds = {premiumId};

  static Future<void> initialize() async {
    final available = await _iap.isAvailable();
    if (!available) {
      debugPrint('[IAP] Store unavailable');
      return;
    }

    // Optionally: fetch products
    await _iap.queryProductDetails(_productIds);
  }

  static Future<void> restorePurchases({
    required VoidCallback onSuccess,
    required VoidCallback onNothingRestored,
    required VoidCallback onFailure,
    required WidgetRef ref,
  }) async {
    final isAvailable = await _iap.isAvailable();
    if (!isAvailable) {
      onFailure();
      return;
    }

    final restored = Completer<bool>();

    late StreamSubscription<List<PurchaseDetails>> sub;

    sub = _iap.purchaseStream.listen(
      (purchases) async {
        for (final purchase in purchases) {
          if (purchase.status == PurchaseStatus.restored &&
              purchase.productID == premiumId) {
            await _setPremiumActive(ref);
            restored.complete(true);
            break;
          }
        }

        if (!restored.isCompleted) {
          restored.complete(false);
        }
      },
      onDone: () => sub.cancel(),
      onError: (_) {
        if (!restored.isCompleted) restored.completeError('error');
      },
    );

    try {
      await _iap.restorePurchases();

      final found = await restored.future.timeout(const Duration(seconds: 5));
      found ? onSuccess() : onNothingRestored();
    } catch (_) {
      onFailure();
    } finally {
      await sub.cancel();
    }
  }

  static Future<void> _setPremiumActive(WidgetRef ref) async {
    await Hive.box(HiveBoxKeys.appState).put(HiveBoxKeys.hasPremium, true);
    ref.read(premiumProvider.notifier).state = true;
  }

  static Future<void> purchasePremium({
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
    required WidgetRef ref,
  }) async {
    final available = await _iap.isAvailable();
    if (!available) {
      onFailure();
      return;
    }

    final productDetailsResponse = await _iap.queryProductDetails({premiumId});
    if (productDetailsResponse.notFoundIDs.isNotEmpty ||
        productDetailsResponse.productDetails.isEmpty) {
      onFailure();
      return;
    }

    final product = productDetailsResponse.productDetails.first;

    final purchaseParam = PurchaseParam(productDetails: product);

    _iap.buyNonConsumable(purchaseParam: purchaseParam);

    // Listen for the purchase confirmation
    _iap.purchaseStream.listen((purchases) async {
      for (final purchase in purchases) {
        if (purchase.productID == premiumId &&
            purchase.status == PurchaseStatus.purchased) {
          await _setPremiumActive(ref);
          onSuccess();
          break;
        } else if (purchase.status == PurchaseStatus.error) {
          onFailure();
        }
      }
    });
  }
}
