#include <iostream>
#include <string>

#include <time.h>

#include "opencv2/opencv_modules.hpp"

#if defined(HAVE_OPENCV_CUDACODEC)

#include <string>
#include <vector>
#include <algorithm>
#include <numeric>

#include "opencv2/cudafilters.hpp"
#include "opencv2/cudaimgproc.hpp"


#include <opencv2/core.hpp>
#include <opencv2/core/opengl.hpp>
#include <opencv2/cudacodec.hpp>
#include <opencv2/highgui.hpp>
#include "opencv2/core/utility.hpp"
#include "opencv2/cudabgsegm.hpp"
#include "opencv2/cudalegacy.hpp"
#include "opencv2/video.hpp"
#include "opencv2/highgui.hpp"

#include "opencv2/cudaarithm.hpp"

#include "tick_meter.hpp"


using namespace std;
using namespace cv;
using namespace cv::cuda;




int main(int argc, const char* argv[])
{
    if (argc != 2)
        return -1;

    bool showimg = true;
    bool saveimg = false;
    bool showall = false;


    const std::string fname(argv[1]);
   
    cv::namedWindow("CPU", cv::WINDOW_NORMAL);
    cv::namedWindow("Mask", cv::WINDOW_NORMAL);
    cv::namedWindow("GPU", cv::WINDOW_OPENGL);
    cv::namedWindow("CROP", cv::WINDOW_OPENGL);
    cv::cuda::setGlDevice();

    cv::Mat frame;
    cv::Mat orig_frame;
    cv::Mat fgmask;

    cv::VideoCapture reader(fname);

    cv::cuda::GpuMat d_frame;
    cv::cuda::GpuMat d_fgmask;
    cv::cuda::GpuMat d_bgimg;
 

    cv::Ptr<cv::cudacodec::VideoReader> d_reader = cv::cudacodec::createVideoReader(fname);

    int bShadowDetection = false;
    int history = 400;
    int varThreshold = 100;

    Ptr<BackgroundSubtractor> mog2 = cuda::createBackgroundSubtractorMOG2(history, varThreshold, bShadowDetection);


    TickMeter tm;
    std::vector<double> cpu_times;
    std::vector<double> gpu_times;


    clock_t start, end;
    double elapsed;
    start = clock();
 int counter = 0;
 int framenum = 0;

/* DIALATE */
        int erosionDilation_size = 5;// Was 5
        Mat element = cv::getStructuringElement(MORPH_RECT, Size(2*erosionDilation_size + 1,    2*erosionDilation_size+1));

        cv::cuda::GpuMat d_element(element);

	// MORPH_OPEN  MORPH_DILATE MORPH_CLOSE
        Ptr<cuda::Filter> dilateFilter = cuda::createMorphologyFilter(MORPH_CLOSE, d_fgmask.type(), element);

        Mat element2 = cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(40, 40));
        cv::cuda::GpuMat d_element2(element2);
        Ptr<cuda::Filter> dilateFilter2 = cuda::createMorphologyFilter(MORPH_CLOSE, d_fgmask.type(), element2);

	
 for (;;)
    {
    framenum++;
        if (!d_reader->nextFrame(d_frame))
            break;


        mog2->apply(d_frame, d_fgmask);
//        mog2->getBackgroundImage(d_bgimg);
	
//        dilateFilter->apply(d_fgmask, d_fgmask);
//        dilateFilter2->apply(d_fgmask, d_fgmask);


        int pixels =  cv::cuda::countNonZero(d_fgmask);

	//if ((pixels > 8000) && (framenum > 1) ){
        if (pixels > 3000  || showall){

	        dilateFilter2->apply(d_fgmask, d_fgmask);


		counter++;
		d_frame.download(frame);
                d_fgmask.download(fgmask);
		d_frame.download(orig_frame);




                vector<vector<Point> > contours;
                vector<Vec4i> hierarchy;

		double maxcontour = 0;
                findContours( fgmask, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, Point(0, 0) );


                for( int i = 0; i< contours.size(); i++ ) {
			
			double a=contourArea( contours[i],false);  //  Find the area of contour
			if (a > maxcontour) {
				maxcontour = a;
			}
		}

  		saveimg = true;
		if(saveimg && maxcontour > 200) {


			////
			  /// Approximate contours to polygons + get bounding rects and circles
			  vector<vector<Point> > contours_poly( contours.size() );
			  vector<Rect> boundRect( contours.size() );
			  vector<Point2f>center( contours.size() );
			  vector<float>radius( contours.size() );

			  for( int i = 0; i < contours.size(); i++ )
			     { approxPolyDP( Mat(contours[i]), contours_poly[i], 3, true );
			       minEnclosingCircle( (Mat)contours_poly[i], center[i], radius[i] );
			     }


			  /// Draw polygonal contour + bonding rects + circles
			  for( int i = 0; i< contours.size(); i++ )
			     {
				Scalar color = Scalar( 128, 255, 255 );

				drawContours( frame, contours_poly, i, color, 1, 8, vector<Vec4i>(), 0, Point() );

			       if((int)radius[i] > 40) {
				circle( frame, center[i], 2*(int)radius[i], color, 2, 8, 0 );


				int x = (int)center[i].x;
				int y = (int)center[i].y;
				int xyradius = 2*(int)radius[i];

				int xpos = 0;
				int ypos = 0;
				int height = 960;
				int width = 1280;

				
      if(xyradius > x) {
         xpos = 0 ;
	std::cout << "Left border\n"; 

	}

      else if (xyradius+x > width){
         xpos = width - (2*xyradius);

	std::cout << "Right border\n"; 
	
}
        else {

		std::cout << "Horisontal center\n"; 
        	xpos = x-xyradius;
	}
        if (xyradius > y){
         ypos = 0;

		std::cout << "Top border\n"; 

}

        else if (xyradius+y > height) {
         ypos = height - (2*xyradius);
		std::cout << "Bottom border\n"; 

}
        else {
		std::cout << "Vertical center\n"; 

         ypos = y-xyradius;

	}

        int lengde=2*xyradius;

	cv::Rect rect(xpos, ypos, lengde-1, lengde-1);

	//Mat cropedImage = frame(rect);

	
		int clen=xpos+lengde;
		int ch=ypos+lengde;
				std::cout << xpos << "- " << clen << " -- " << ypos << "-" << ch << "\n"; 
	
	if(clen<=width && ch<=height){
	cv::Rect rect2(600, 600, 200, 200);
  	cv::Mat croppedImage = orig_frame(rect);

	cv::Size size(240,240);
	cv::Mat resized;//dst image
	resize(croppedImage,resized,size);//resize image

	cv::rectangle(frame, rect, cv::Scalar(0, 255, 0));

//        rectangle(frame,(xpos,ypos),(xpos+lengde,ypos+lengde),(0,255,255),2);

			char filenamec[30] = {0};
	                //(unsigned char const *,int,unsigned char const *,int,bool);
        	        sprintf(filenamec,"file-%04d_crop%04d.jpg",counter, i);
	                imwrite(filenamec, resized );
	
	}

				}
			     }


			char filename[30] = {0};
	                //(unsigned char const *,int,unsigned char const *,int,bool);
        	        sprintf(filename,"file-%04d.jpg",counter);
	                imwrite(filename, frame );
	                //sprintf(filename,"fgmask-%04d.jpg",counter);
	                //imwrite(filename, fgmask );
		}

                std::cout << "White pixels " << pixels << "  @ frame " << framenum <<  "  Largest blob "   << maxcontour  << "  Saved with ext " << counter << "\n" ;


		showimg = true;
		if(showimg && maxcontour > 200) {
			cv::imshow("CPU", frame);
	                cv::imshow("Mask", fgmask);

        		if (cv::waitKey(1) > 0)
        			break;
		}
	}
    }


    end = clock();
    elapsed = ((double) (end - start)) / CLOCKS_PER_SEC;
    std::cout << "Processed video in " << elapsed << "seconds\n";


    return 0;
}

#else

int main()
{
    std::cout << "OpenCV was built without CUDA Video decoding support\n" << std::endl;
    return 0;
}

#endif
