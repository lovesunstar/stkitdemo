//This file is part of SphereView.
//
//SphereView is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.
//
//SphereView is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with SphereView.  If not, see <http://www.gnu.org/licenses/>.

#import "PFGoldenSectionSpiral.h"

PFMatrix const PFMatrixZero = {0,0,{{0,0,0,0}, {0,0,0,0}, {0,0,0,0}, {0,0,0,0}}};

@implementation PFGoldenSectionSpiral

+ (NSArray *)sphere:(NSInteger)n {
	NSMutableArray* result = [NSMutableArray arrayWithCapacity:n];
	STFloat32 N = n;
	STFloat32 inc = M_PI * (3.0f - sqrt(5.0f));
    STFloat32 off = 2.0f / N;
	for (NSInteger k = 0; k < N; k ++) {
        STFloat32 y = k * off - 1.0f + (off / 2.0f);
        STFloat32 r = sqrt(1.0f - y*y);
        STFloat32 phi = k * inc;
		PFPoint point = PFPointMake(cos(phi)*r, y, sin(phi)*r);
        [result addObject:NSStringFromPFPoint(point)];
	}
	
	return result;
}

@end


extern PFRadian PFRadianMake(STFloat32 grades) {
    return ((STFloat32)(M_PI * grades) / 180.0f);
}

extern PFMatrix PFMatrixTransform3DMakeFromPFPoint(PFPoint point) {
    STFloat32 pointRef[1][4] = {{point.x, point.y, point.z, 1.0f}};
    
    PFMatrix matrix = PFMatrixMakeFromArray(1, 4, * pointRef);
    
    return matrix;
}

extern PFMatrix PFMatrixTransform3DMakeTranslation(PFPoint point) {
    STFloat32 T[4][4] = {
        {1.0f, 0.f, 0.f, 0.f},
        {0.f, 1.f, 0.f, 0.f},
        {0.f, 0.f, 1.f, 0.f},
        {point.x, point.y, point.z, 1.0f}
    };
    
    PFMatrix matrix = PFMatrixMakeFromArray(4, 4, *T);
    return matrix;
}

extern PFMatrix PFMatrixTransform3DMakeXRotation(PFRadian angle) {
    STFloat32 c = cos(PFRadianMake(angle));
    STFloat32 s = sin(PFRadianMake(angle));
    
    STFloat32 T[4][4] = {
        {1.f, 0.f, 0.f, 0.f},
        {0.f, c, s, 0.f},
        {0.f, -s, c, 0.f},
        {0.f, 0.f, 0.f, 1.f}
    };
    
    PFMatrix matrix = PFMatrixMakeFromArray(4, 4, *T);
    
    return matrix;
}

extern PFMatrix PFMatrixTransform3DMakeXRotationOnPoint(PFPoint point, PFRadian angle) {
    PFMatrix T = PFMatrixTransform3DMakeTranslation(PFPointMake(-point.x, -point.y, -point.z));
    PFMatrix R = PFMatrixTransform3DMakeXRotation(angle);
    PFMatrix T1 = PFMatrixTransform3DMakeTranslation(point);
    
    return PFMatrixMultiply(PFMatrixMultiply(T, R), T1);
}

extern PFMatrix PFMatrixTransform3DMakeYRotation(PFRadian angle) {
    STFloat32 c = cos(PFRadianMake(angle));
    STFloat32 s = sin(PFRadianMake(angle));
    
    STFloat32 T[4][4] = {
        {c, 0, -s, 0},
        {0, 1, 0, 0},
        {s, 0, c, 0},
        {0, 0, 0, 1}
    };
    
    PFMatrix matrix = PFMatrixMakeFromArray(4, 4, *T);
    
    return matrix;
}

extern PFMatrix PFMatrixTransform3DMakeYRotationOnPoint(PFPoint point, PFRadian angle) {
    PFMatrix T = PFMatrixTransform3DMakeTranslation(PFPointMake(-point.x, -point.y, -point.z));
    PFMatrix R = PFMatrixTransform3DMakeYRotation(angle);
    PFMatrix T1 = PFMatrixTransform3DMakeTranslation(point);
    
    return PFMatrixMultiply(PFMatrixMultiply(T, R), T1);
}

extern PFMatrix PFMatrixTransform3DMakeZRotation(PFRadian angle) {
    STFloat32 c = cos(PFRadianMake(angle));
    STFloat32 s = sin(PFRadianMake(angle));
    
    STFloat32 T[4][4] = {
        {c,  s, 0.0f, 0.0f},
        {-s, c, 0.0f, 0.0f},
        {0,0.0f,0.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 1.0f}
    };
    
    PFMatrix matrix = PFMatrixMakeFromArray(4, 4, *T);
    
    return matrix;
}

extern PFMatrix PFMatrixTransform3DMakeZRotationOnPoint(PFPoint point, PFRadian angle) {
    PFMatrix T = PFMatrixTransform3DMakeTranslation(PFPointMake(-point.x, -point.y, -point.z));
    PFMatrix R = PFMatrixTransform3DMakeZRotation(angle);
    PFMatrix T1 = PFMatrixTransform3DMakeTranslation(point);
    
    return PFMatrixMultiply(PFMatrixMultiply(T, R), T1);
}



extern PFMatrix PFMatrixMake(NSInteger m, NSInteger n) {
    PFMatrix matrix = PFMatrixZero;
    matrix.m = m;
    matrix.n = n;
    for (NSInteger i = 0; i < m; i ++){
        for(NSInteger j = 0; j < n; j ++){
            matrix.data[i][j] = (STFloat32)0.0f;
        }
    }
    return matrix;
}

extern PFMatrix PFMatrixMakeFromArray(NSInteger m, NSInteger n, STFloat32 *data) {
    PFMatrix matrix = PFMatrixMake(m, n);
    for (NSInteger i = 0; i < m; i ++) {
        STFloat32 *t = data+(i*sizeof(STFloat32));
        for(NSInteger j = 0; j < n; j++) {
            matrix.data[i][j] = *(t+j);
        }
    }
    
    return matrix;
}

extern PFMatrix PFMatrixMakeIdentity(NSInteger m, NSInteger n) {
    PFMatrix matrix = PFMatrixMake(m, n);
    for (NSInteger i = 0; i < m; i++){
        matrix.data[i][i] = 1.0f;
    }
    
    return matrix;
}

extern PFMatrix PFMatrixMultiply(PFMatrix A, PFMatrix B) {
    PFMatrix R = PFMatrixMake(A.m, B.n);
    for(NSInteger i = 0; i < A.m; i++){
        for(NSInteger j = 0; j < B.n; j++){
            for(NSInteger k = 0; k < A.n; k++){
                R.data[i][j] += (A.data[i][k] * B.data[k][j]);
            }
        }
    }
    
    return R;
}

extern NSString *NSStringFromPFMatrix(PFMatrix matrix) {
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"{"];
    for(NSInteger i=0; i<matrix.m; i++){
        [str appendString:@"\n{"];
        for(NSInteger j=0; j<matrix.n; j++){
            [str appendFormat:@"%f",matrix.data[i][j]];
            
            if (j+1 < matrix.n) {
                [str appendString:@","];
            }
        }
        [str appendString:@"}"];
        
        if (i+1 < matrix.m) {
            [str appendString:@","];
        }
    }
    [str appendString:@"\n}"];
    
    return str;
}


extern PFPoint PFPointMake(STFloat32 x, STFloat32 y, STFloat32 z) {
    PFPoint p;
    p.x = x;
    p.y = y;
    p.z = z;
    return p;
}

extern PFPoint PFPointMakeFromMatrix(PFMatrix matrix) {
    return PFPointMake(matrix.data[0][0], matrix.data[0][1], matrix.data[0][2]);
}

extern PFPoint PFPointFromString(NSString *string) {
    PFPoint p;
    NSArray *temp = [string componentsSeparatedByString:@","];
    if (temp.count > 0) {
        p.x = [temp[0] floatValue];
    }
    if (temp.count > 1) {
        p.y = [temp[1] floatValue];
    }
    if (temp.count > 2) {
        p.z = [temp[2] floatValue];
    }
    return p;
}


extern NSString *NSStringFromPFPoint(PFPoint point) {
    return [NSString stringWithFormat:@"%@,%@,%@", @(point.x), @(point.y), @(point.z)];
}


#pragma mark -
#pragma mark CGPoint methods

extern CGPoint CGPointMakeNormalizedPoint(CGPoint point, STFloat32 distance) {
    return CGPointMake(point.x * 1.0f / distance, point.y * 1.0f / distance);
}



extern PFAxisDirection PFAxisDirectionMake(STFloat32 fromCoordinate, STFloat32 toCoordinate, BOOL sensitive) {
    PFAxisDirection direction = PFAxisDirectionNone;
    
    STFloat32 distance = fabs(fromCoordinate - toCoordinate);
				
    if (distance > PFAxisDirectionMinimumDistance || sensitive) {
        if (fromCoordinate > toCoordinate) {
            direction = PFAxisDirectionPositive;
        } else if (fromCoordinate < toCoordinate) {
            direction = PFAxisDirectionNegative;
        }
    }
    
    return direction;
}

extern PFAxisDirection PFDirectionMakeXAxis(CGPoint fromPoint, CGPoint toPoint) {
    return PFAxisDirectionMake(fromPoint.x, toPoint.x, NO);
}

extern PFAxisDirection PFDirectionMakeYAxis(CGPoint fromPoint, CGPoint toPoint) {
    return PFAxisDirectionMake(fromPoint.y, toPoint.y, NO);
}

extern PFAxisDirection PFDirectionMakeXAxisSensitive(CGPoint fromPoint, CGPoint toPoint) {
    return PFAxisDirectionMake(fromPoint.x, toPoint.x, YES);
}

extern PFAxisDirection PFDirectionMakeYAxisSensitive(CGPoint fromPoint, CGPoint toPoint) {
    return PFAxisDirectionMake(fromPoint.y, toPoint.y, YES);
}

