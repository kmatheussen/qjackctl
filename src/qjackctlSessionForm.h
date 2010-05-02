// qjackctlSessionForm.h
//
/****************************************************************************
   Copyright (C) 2003-2010, rncbc aka Rui Nuno Capela. All rights reserved.

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version 2
   of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along
   with this program; if not, write to the Free Software Foundation, Inc.,
   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

*****************************************************************************/

#ifndef __qjackctlSessionForm_h
#define __qjackctlSessionForm_h

#include <QtGlobal>

#if QT_VERSION < 0x040200
#define setAllColumnsShowFocus(x) parent()
#endif

#include "ui_qjackctlSessionForm.h"

// Forward declarations.
class qjackctlSession;

class QMenu;


//----------------------------------------------------------------------------
// qjackctlSessionForm -- UI wrapper form.

class qjackctlSessionForm : public QWidget
{
	Q_OBJECT

public:

	// Constructor.
	qjackctlSessionForm(QWidget *pParent = 0, Qt::WindowFlags wflags = 0);
	// Destructor.
	~qjackctlSessionForm();

	// Recent session directories accessors.
	void setSessionDirs(const QStringList& sessionDirs);
	const QStringList& sessionDirs() const;

	// Recent menu accessor.
	QMenu *recentMenu() const;

	void stabilizeForm(bool bEnabled);

public slots:

	void loadSession();
	void saveSession();

	void saveSessionSave();
	void saveSessionSaveAndQuit();
	void saveSessionSaveTemplate();

	void updateSession();

protected slots:

	void recentSession();
	void updateRecentMenu();
	void clearRecentMenu();

protected:

	void showEvent(QShowEvent *);
	void hideEvent(QHideEvent *);
	void closeEvent(QCloseEvent *);

	void keyPressEvent(QKeyEvent *);

	void saveSessionEx(int iSessionType = 0);

	void loadSessionDir(const QString& sSessionDir);
	void saveSessionDir(const QString& sSessionDir, int iSessionType = 0);

	void updateRecent(const QString& sSessionDir);

	void updateSessionView();

private:

	// The Qt-designer UI struct...
	Ui::qjackctlSessionForm m_ui;

	// Common (sigleton) session object.
	qjackctlSession *m_pSession;
	
	// Recent session menu.
	QMenu *m_pRecentMenu;

	// Session directory history.
	QStringList m_sessionDirs;
};


#endif	// __qjackctlSessionForm_h


// end of qjackctlSessionForm.h