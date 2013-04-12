    //
    //  ViewController.m
    //  appStoreScrollView
    //
    //  Created by Rob Mayoff on 4/11/13.
    //  Copyright (c) 2013 Rob Mayoff. All rights reserved.
    //

    #import "ViewController.h"
    #import "MyCell.h"

    @interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

    @property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

    @end

    @implementation ViewController {
        NSString *cellClassName;
        CGFloat baseOffset;
        CGFloat offsetStep;
    }

    - (void)viewDidLoad {
        [super viewDidLoad];
        cellClassName = NSStringFromClass([MyCell class]);
        [self.collectionView registerNib:[UINib nibWithNibName:cellClassName bundle:nil] forCellWithReuseIdentifier:cellClassName];
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }

    - (void)viewDidLayoutSubviews {
        [super viewDidLayoutSubviews];
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        CGFloat stepUnit = layout.itemSize.width + layout.minimumLineSpacing;
        offsetStep = stepUnit * floorf(self.collectionView.bounds.size.width / stepUnit);
    }

    - (void)viewDidAppear:(BOOL)animated {
        [super viewDidAppear:animated];
        baseOffset = self.collectionView.contentOffset.x;
    }

    #pragma mark - UICollectionViewDataSource protocol

    - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
        return 1;
    }

    - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return 12;
    }

    - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellClassName forIndexPath:indexPath];
        cell.label.text = [NSString stringWithFormat:@"%d", indexPath.item];
        return cell;
    }

    #pragma mark - UICollectionViewDelegate protocol

    - (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
        if (velocity.x < 0) {
            baseOffset = MAX(0, baseOffset - offsetStep);
        } else if (velocity.x > 0) {
            baseOffset = MIN(scrollView.contentSize.width - scrollView.bounds.size.width, baseOffset + offsetStep);
        }
    #if 0
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointMake(baseOffset, 0) animated:YES];
        });
    #else
        targetContentOffset->x = baseOffset;
    #endif
    }

    @end
