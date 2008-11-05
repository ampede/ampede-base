//
//  DSAppDefines.h
//  Ampede
//
//  Taken from OmniBase/FrameworkDefines.h
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#ifndef _DSAppDEFINES_H
#define _DSAppDEFINES_H

//
//  OpenStep/Mach or Rhapsody
//

#if defined(__MACH__)

#ifdef __cplusplus
#define DS_EXTERN               extern
#define DS_PRIVATE_EXTERN       __private_extern__
#else
#define DS_EXTERN               extern
#define DS_PRIVATE_EXTERN       __private_extern__
#endif


//
//  OpenStep/NT, YellowBox/NT, and YellowBox/95
//

#elif defined(WIN32)

#ifndef _NSBUILDING_OmniBase_DLL
#define _OmniBase_WINDOWS_DLL_GOOP       __declspec(dllimport)
#else
#define _OmniBase_WINDOWS_DLL_GOOP       __declspec(dllexport)
#endif

#ifdef __cplusplus
#define OmniBase_EXTERN			_OmniBase_WINDOWS_DLL_GOOP extern
#define OmniBase_PRIVATE_EXTERN		extern
#else
#define OmniBase_EXTERN			_OmniBase_WINDOWS_DLL_GOOP extern
#define OmniBase_PRIVATE_EXTERN		extern
#endif

//
// Standard UNIX: PDO/Solaris, PDO/HP-UX, GNUstep
//

#elif defined(sun) || defined(hpux) || defined(GNUSTEP)

#ifdef __cplusplus
#  define OmniBase_EXTERN               extern
#  define OmniBase_PRIVATE_EXTERN       extern
#else
#  define OmniBase_EXTERN               extern
#  define OmniBase_PRIVATE_EXTERN       extern
#endif

#else

#error Do not know how to define extern on this platform

#endif

#endif // _DSAppDEFINES_H
