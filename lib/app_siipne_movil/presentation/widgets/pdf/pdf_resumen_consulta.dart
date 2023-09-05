import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../../app/core/utils/my_date.dart';
import '../../../../app/core/utils/save_file_mobile.dart';
import '../../../../app/core/values/app_images.dart';
import '../../../data/models/models.dart';

class PdfResumenConsulta {
  static Future<String?> _generatePDF() async {
    //Create a new PDF document
    final PdfDocument document = PdfDocument();
    //Draw image
    document.pages.add().graphics.drawImage(
        PdfBitmap(await _readImageData(AppImages.icon_camara)),
        const Rect.fromLTWH(50, 50, 425, 642));
    final PdfPage titlePage = document.pages.add();
    //Draw text
    titlePage.graphics.drawString(
        'texto de la cabecera', PdfStandardFont(PdfFontFamily.timesRoman, 30),
        bounds: Rect.fromLTWH(0, 60, titlePage.getClientSize().width,
            titlePage.getClientSize().height),
        format: PdfStringFormat(alignment: PdfTextAlignment.center));
    titlePage.graphics.drawImage(
        PdfBitmap(await _readImageData(AppImages.icon_buscar)),
        const Rect.fromLTWH(40, 110, 435, 5));
    final PdfStringFormat format =
        PdfStringFormat(alignment: PdfTextAlignment.center);
    titlePage.graphics.drawString('By\nRyan Hodson',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(0, 130, titlePage.getClientSize().width,
            titlePage.getClientSize().height),
        format: format);
    titlePage.graphics.drawString('Foreword by Daniel Jebaraj',
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: Rect.fromLTWH(0, 220, titlePage.getClientSize().width,
            titlePage.getClientSize().height),
        format: format);
    //Add new Section
    final PdfSection section = document.sections!.add();
    final PdfPage contentPage = section.pages.add();
    _addParagraph(contentPage, 'Table of Contents',
        Rect.fromLTWH(20, 60, 495, contentPage.getClientSize().height), true,
        mainTitle: true);

    //Create a header template and draw a text.
    final PdfPageTemplateElement headerElement =
        PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50), contentPage);
    headerElement.graphics.setTransparency(0.6);

    headerElement.graphics.drawString(
        'aquiiiii', PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(0, 0, 515, 50),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.right,
            lineAlignment: PdfVerticalAlignment.middle));

    headerElement.graphics
        .drawLine(PdfPens.gray, const Offset(0, 49), const Offset(515, 49));
    section.template.top = headerElement;

    //Create a footer template and draw a text.
    final PdfPageTemplateElement footerElement =
        PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50), contentPage);
    footerElement.graphics.setTransparency(0.6);
    PdfCompositeField(text: 'Page {0} of {1}', fields: <PdfAutomaticField>[
      PdfPageNumberField(brush: PdfBrushes.black),
      PdfPageCountField(brush: PdfBrushes.black)
    ]).draw(footerElement.graphics, const Offset(450, 35));
    section.template.bottom = footerElement;

    //Add a new PDF page
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    //Draw string.
    //Draw text
    PdfLayoutResult result = _addParagraph(
        page, 'Introduction', Rect.fromLTWH(20, 25, 495, pageSize.height), true,
        mainTitle: true);
    //Add to table of content
    PdfLayoutResult tableContent = _addTableOfContents(
        contentPage,
        'Introduction',
        Rect.fromLTWH(20, 110, 470, result.page.getClientSize().height),
        true,
        4,
        20,
        result.bounds.top,
        result.page);
    //Add bookmark
    _addBookmark(page, 'Introduction', result.bounds.topLeft, doc: document);
    result = _addParagraph(
        result.page,
        "Adobe Systems Incorporated's Portable Document Format (PDF) is the de facto standard for the accurate, reliable, and platform-independent representation of a paged document. It's the only universally accepted file format that allows pixel-perfect layouts. In addition, PDF supports user interaction and collaborative workflows that are not possible with printed documents.\n\nPDF documents have been in widespread use for years, and dozens of free and commercial PDF readers, editors, and libraries are readily available. However, despite this popularity, it's still difficult to find a succinct guide to the native PDF format. Understanding the internal workings of a PDF makes it possible to dynamically generate PDF documents. For example, a web server can extract information from a database, use it to customize an invoice, and serve it to the customer on the fly.",
        Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
        false);
    result = _addParagraph(
        result.page,
        'The PDF Standard',
        Rect.fromLTWH(20, result.bounds.bottom + 25, 495, pageSize.height),
        true);
    tableContent = _addTableOfContents(
        tableContent.page,
        'The PDF Standard',
        Rect.fromLTWH(20, tableContent.bounds.bottom, 470,
            result.page.getClientSize().height),
        false,
        4,
        20,
        result.bounds.top,
        result.page);
    _addBookmark(result.page, 'The PDF Standard', result.bounds.topLeft,
        doc: document);
    result = _addParagraph(
        result.page,
        'The PDF format is an open standard maintained by the International Organization for Standardization. The official specification is defined in ISO 32000-1:2008, but Adobe also provides a free, comprehensive guide called PDF Reference, Sixth Edition, version 1.7.',
        Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
        false);
    result = _addParagraph(
        result.page,
        'Chapter 1 Conceptual Overview',
        Rect.fromLTWH(20, result.bounds.bottom + 25, 495, pageSize.height),
        true,
        mainTitle: true);
    tableContent = _addTableOfContents(
        tableContent.page,
        'Chapter 1 Conceptual Overview',
        Rect.fromLTWH(20, tableContent.bounds.bottom, 470,
            result.page.getClientSize().height),
        true,
        4,
        20,
        result.bounds.top,
        result.page);
    final PdfBookmark standardBookmark = _addBookmark(
        result.page, 'Chapter 1 Conceptual Overview', result.bounds.topLeft,
        doc: document);
    result = _addParagraph(
        result.page,
        "We'll begin with a conceptual overview of a simple PDF document. This chapter is designed to be a brief orientation before diving in and creating a real document from scratch.\nA PDF file can be divided into four parts: a header, body, cross-reference table, and trailer. The header marks the file as a PDF, the body defines the visible document, the cross-reference table lists the location of everything in the file, and the trailer provides instructions for how to start reading the file.",
        Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
        false);
    final PdfPage page2 = document.pages.add();
    page2.graphics.drawImage(
        PdfBitmap(await _readImageData(AppImages.icon_huella)),
        const Rect.fromLTWH(10, 0, 495, 600));
    result = _addParagraph(
        page2,
        'Every PDF file must have these four components.',
        Rect.fromLTWH(20, 620, 495, page2.getClientSize().height),
        false);
    result = _addParagraph(document.pages.add(), 'Header',
        Rect.fromLTWH(20, 15, 495, pageSize.height), true);
    tableContent = _addTableOfContents(
        tableContent.page,
        'Header',
        Rect.fromLTWH(20, tableContent.bounds.bottom, 470,
            result.page.getClientSize().height),
        false,
        6,
        20,
        result.bounds.top,
        result.page);
    _addBookmark(result.page, 'Header', result.bounds.topLeft,
        bookmark: standardBookmark);
    result = _addParagraph(
        result.page,
        'The header is simply a PDF version number and an arbitrary sequence of binary data. The binary data prevents naïve applications from processing the PDF as a text file. This would result in a corrupted file, since a PDF typically consists of both plain text and binary data (e.g., a binary font file can be directly embedded in a PDF).',
        Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
        false);
    result = _addParagraph(
        result.page,
        'Body',
        Rect.fromLTWH(20, result.bounds.bottom + 25, 495, pageSize.height),
        true);
    tableContent = _addTableOfContents(
        tableContent.page,
        'Body',
        Rect.fromLTWH(20, tableContent.bounds.bottom, 470,
            result.page.getClientSize().height),
        false,
        6,
        20,
        result.bounds.top,
        result.page);
    _addBookmark(result.page, 'Body', result.bounds.topLeft,
        bookmark: standardBookmark);
    result = _addParagraph(
        result.page,
        'The body of a PDF contains the entire visible document. The minimum elements required in a valid PDF body are:\n\n1. A page tree \n2. Pages \n3. Resources \n4. Content \n5. The catalog \n\nThe page tree serves as the root of the document. In the simplest case, it is just a list of the pages in the document. Each page is defined as an independent entity with metadata (e.g., page dimensions) and a reference to its resources and content, which are defined separately. Together, the page tree and page objects create the "paper" that composes the document.\n\nResources are objects that are required to render a page. For example, a single font is typically used across several pages, so storing the font information in an external resource is much more efficient. A content object defines the text and graphics that actually show up on the page. Together, content objects and resources define the appearance of an individual page.\nFinally, the document\'s catalog tells applications where to start reading the document. Often, this is just a pointer to the root page tree.',
        Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
        false);
    final PdfPage page3 = document.pages.add();
    page3.graphics.drawImage(
        PdfBitmap(await _readImageData(AppImages.icon_timer)),
        const Rect.fromLTWH(20, 0, 300, 400));
    result = _addParagraph(page3, 'Cross-Reference Table',
        Rect.fromLTWH(20, 425, 495, pageSize.height), true);
    tableContent = _addTableOfContents(
        tableContent.page,
        'Cross-Reference Table',
        Rect.fromLTWH(20, tableContent.bounds.bottom, 470,
            result.page.getClientSize().height),
        false,
        7,
        20,
        result.bounds.top,
        result.page);
    _addBookmark(result.page, 'Cross-Reference Table', result.bounds.topLeft,
        bookmark: standardBookmark);
    result = _addParagraph(
        result.page,
        'After the header and the body comes the cross-reference table. It records the byte location of each object in the body of the file. This enables random-access of the document, so when rendering a page, only the objects required for that page are read from the file. This makes PDFs much faster than their PostScript predecessors, which had to read in the entire file before processing it.',
        Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
        false);
    result = _addParagraph(
        result.page,
        'Trailer',
        Rect.fromLTWH(20, result.bounds.bottom + 25, 495, pageSize.height),
        true);
    tableContent = _addTableOfContents(
        tableContent.page,
        'Trailer',
        Rect.fromLTWH(20, tableContent.bounds.bottom, 470,
            result.page.getClientSize().height),
        false,
        7,
        20,
        result.bounds.top,
        result.page);
    _addBookmark(result.page, 'Trailer', result.bounds.topLeft,
        bookmark: standardBookmark);
    result = _addParagraph(
        result.page,
        'Finally, we come to the last component of a PDF document. The trailer tells applications how to start reading the file. At minimum, it contains three things:\n\n\n1. A reference to the catalog which links to the root of the document.\n2. The location of the cross-reference table.\n3. The size of the cross-reference table.\n\nSince a trailer is all you need to begin processing a document, PDFs are typically read back-to-front: first, the end of the file is found, and then you read backwards until you arrive at the beginning of the trailer. After that, you should have all the information you need to load any page in the PDF.',
        Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
        false);
    result = _addParagraph(
        result.page,
        'Summary',
        Rect.fromLTWH(20, result.bounds.bottom + 25, 495, pageSize.height),
        true);
    tableContent = _addTableOfContents(
        tableContent.page,
        'Summary',
        Rect.fromLTWH(20, tableContent.bounds.bottom, 470,
            result.page.getClientSize().height),
        false,
        8,
        20,
        result.bounds.top,
        result.page);
    _addBookmark(result.page, 'Summary', result.bounds.topLeft,
        bookmark: standardBookmark);
    result = _addParagraph(
        result.page,
        'To conclude our overview, a PDF document has a header, a body, a cross-reference table, and a trailer. The trailer serves as the entryway to the entire document, giving you access to any object via the cross-reference table, and pointing you toward the root of the document. The relationship between these elements is shown in the following figure.',
        Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
        false);
    result.page.graphics.drawImage(
        PdfBitmap(await _readImageData(AppImages.iconCancelar)),
        Rect.fromLTWH(20, result.bounds.bottom + 20, 495, 400));

    final List<int> bytes = await document.save();
    document.dispose();
    //Launch file.

    String namePdf = "Reporte_operativo_}";
    String? pathPdf =
        await FileSaveHelper.saveAndLaunchFile(bytes, '${namePdf}.pdf');

    return pathPdf;
  }

  static PdfLayoutResult _addParagraph(
      PdfPage page, String text, Rect bounds, bool isTitle,
      {bool mainTitle = false}) {
    return PdfTextElement(
            text: text,
            font: PdfStandardFont(
                getFormatoTexto,
                isTitle
                    ? mainTitle
                        ? 24
                        : 18
                    : 13,
                style: (isTitle && !mainTitle)
                    ? PdfFontStyle.bold
                    : PdfFontStyle.regular),
            format: mainTitle
                ? PdfStringFormat(alignment: PdfTextAlignment.center)
                : PdfStringFormat(alignment: PdfTextAlignment.justify))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(
                bounds.left, bounds.top, bounds.width, bounds.height))!;
  }

  static PdfBookmark _addBookmark(PdfPage page, String text, Offset point,
      {PdfDocument? doc, PdfBookmark? bookmark, PdfColor? color}) {
    PdfBookmark book;
    if (doc != null) {
      book = doc.bookmarks.add(text);
      book.destination = PdfDestination(page, point);
    } else {
      book = bookmark!.add(text);
      book.destination = PdfDestination(page, point);
    }
    book.color = color ?? PdfColor(0, 0, 0);
    return book;
  }

  static PdfLayoutResult _addTableOfContents(
      PdfPage page,
      String text,
      Rect bounds,
      bool isTitle,
      int pageNo,
      double x,
      double y,
      PdfPage destPage) {
    final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 13,
        style: isTitle ? PdfFontStyle.bold : PdfFontStyle.regular);
    page.graphics.drawString(pageNo.toString(), font,
        bounds:
            Rect.fromLTWH(480, bounds.top + 5, bounds.width, bounds.height));
    final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
        Rect.fromLTWH(isTitle ? bounds.left : bounds.left + 20, bounds.top - 45,
            isTitle ? bounds.width : bounds.width - 20, font.height),
        PdfDestination(destPage, Offset(x, y)));
    annotation.border.width = 0;
    page.annotations.add(annotation);
    String str = text + ' ';
    final num value = isTitle
        ? font.measureString(text).width.round() + 20
        : font.measureString(text).width.round() + 40;
    for (num i = value; i < 470;) {
      str = str + '.';
      i = i + 3.6140000000000003;
    }
    return PdfTextElement(text: str, font: font).draw(
        page: page,
        bounds: Rect.fromLTWH(isTitle ? bounds.left : bounds.left + 20,
            bounds.top + 5, bounds.width, bounds.height))!;
  }

  static get getFormatoTexto => PdfFontFamily.timesRoman;

  static Future<String?> generatePDF(
      List<DataResumenConsulta> dataResumenConsulta, int idOperativo,String nombreUsuario) async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF

    final PdfSection section = document.sections!.add();
    PdfPage page = section.pages.add();

    //Generate PDF grid.

    //Draw the header section by creating text element

    PdfLayoutResult result = await _drawCabecera(page, idOperativo, section);


    showPiePage(page,section);

//en seult se guarda la posicion de los elementos dibujados, pudeindo sacar la ultima posicion en que se dibujo,

    result = dibujarTituloQuienGenera(result, nombreUsuario);
    result = _drawGridTotales(page, result, dataResumenConsulta);

    result = dibujarTituloConsultaPersonas(result, 10);
    result = _drawGrid(page, result, dataResumenConsulta);

    //dibujarMarcoHoja(  result.page);
    //Save and dispose the document.
    final List<int> bytes = await document.save();
    document.dispose();
    //Launch file.

    String namePdf = "Reporte_operativo_${idOperativo}";
    String? pathPdf =
        await FileSaveHelper.saveAndLaunchFile(bytes, '${namePdf}.pdf');

    return pathPdf;
  }

  static dibujarMarcoHoja(PdfPage page) {
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Dibuja el rectangulo a la hoja
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219, 255)));
  }

  static showPiePage(PdfPage page,PdfSection section){



    final PdfPageTemplateElement footerElement =
    PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 400, 50), page);
    footerElement.graphics.setTransparency(0.5);
    PdfCompositeField(
      font:   PdfStandardFont(getFormatoTexto, 12, style: PdfFontStyle.regular),

        text: 'Página {0} de {1}', fields: <PdfAutomaticField>[
      PdfPageNumberField(brush: PdfBrushes.blue),
      PdfPageCountField(brush: PdfBrushes.blue)
    ]).draw(footerElement.graphics, const Offset(440, 35));
    section.template.bottom = footerElement;


  }

  //Draws the invoice header
  static Future<PdfLayoutResult> _drawCabecera(
      PdfPage page, int idOperativo, PdfSection section) async {
    List<int> imageData = await _readImageData(AppImages.imgbanner);

    final PdfPageTemplateElement headerElement = PdfPageTemplateElement(
        Rect.fromLTWH(1, 1, page.getClientSize().width - 2, 80), page);
    headerElement.graphics.setTransparency(1);

    headerElement.graphics.drawImage(PdfBitmap(imageData),
        Rect.fromLTWH(1, 1, page.getClientSize().width - 2, 80));

    final PdfFont contentFont =
        PdfStandardFont(getFormatoTexto, 10, style: PdfFontStyle.bold);
    String fecha = MyDate.getFechaHoraActual;
    String cabeceraReporte = 'OPERATIVO N°${idOperativo}';

    final Size contentSize = contentFont.measureString(cabeceraReporte);

//FORMULA PARA CENTRAR EL CONTENIDO
    //SE OBTIENE EL TAMÑO DE LA PAGUINA, Y SE RESTA EL TAMAÑO QUE OCUPA EL TEXTO, Y SE DIVIDE PARA 2

    double posicionCenter =
        (page.getClientSize().width - contentSize.width) / 2;
    print("posicionCenter");
    print(posicionCenter);

    headerElement.graphics.drawString(
        cabeceraReporte, contentFont,
        bounds: Rect.fromLTWH(0, 50, 515, 100),
        format: PdfStringFormat(alignment: PdfTextAlignment.center));
    ;
    section.template.top = headerElement;

    return dibujarTitulo(page, idOperativo);
  }

  static PdfLayoutResult dibujarTitulo(PdfPage page, idOperativo) {
    final PdfFont contentFont =
        PdfStandardFont(getFormatoTexto, 18, style: PdfFontStyle.bold);

    String cabeceraReporte = 'REPORTE';

    final Size contentSize = contentFont.measureString(cabeceraReporte);

//FORMULA PARA CENTRAR EL CONTENIDO
    //SE OBTIENE EL TAMÑO DE LA PAGUINA, Y SE RESTA EL TAMAÑO QUE OCUPA EL TEXTO, Y SE DIVIDE PARA 2

    double posicionCenter =
        (page.getClientSize().width - contentSize.width) / 2;
    print("posicionCenter");
    print(posicionCenter);

    return PdfTextElement(text: cabeceraReporte, font: contentFont)
        .draw(page: page, bounds: Rect.fromLTWH(posicionCenter, 0, 0, 0))!;
  }

  static PdfLayoutResult dibujarTituloConsultaPersonas(
      PdfLayoutResult result, int total) {
    final PdfFont contentFont =
        PdfStandardFont(getFormatoTexto, 14, style: PdfFontStyle.bold);

    String cabeceraReporte = 'DETALLE';

    final Size contentSize = contentFont.measureString(cabeceraReporte);

//FORMULA PARA CENTRAR EL CONTENIDO
    //SE OBTIENE EL TAMÑO DE LA PAGUINA, Y SE RESTA EL TAMAÑO QUE OCUPA EL TEXTO, Y SE DIVIDE PARA 2

    double posicionCenter =
        (result.page.getClientSize().width - contentSize.width) / 2;
    print("posicionCenter");
    print(posicionCenter);

    return PdfTextElement(text: cabeceraReporte, font: contentFont).draw(
        page: result.page,
        bounds:
            Rect.fromLTWH(posicionCenter, result.bounds.bottom + 10, 0, 0))!;
  }

  static PdfLayoutResult dibujarTituloQuienGenera(
      PdfLayoutResult result, String nombre) {
    final PdfFont contentFont =
        PdfStandardFont(getFormatoTexto, 10, style: PdfFontStyle.regular);

    String fecha = MyDate.getFechaHoraActual;
    String cabeceraReporte = 'Usuario: ${nombre} \n'
        'Fecha y Hora del Reporte: ${fecha}';

    final Size contentSize = contentFont.measureString(cabeceraReporte);

//FORMULA PARA CENTRAR EL CONTENIDO
    //SE OBTIENE EL TAMÑO DE LA PAGUINA, Y SE RESTA EL TAMAÑO QUE OCUPA EL TEXTO, Y SE DIVIDE PARA 2

    double posicionCenter =
        (result.page.getClientSize().width - contentSize.width) / 2;

    final PdfPen linePen = PdfPen(PdfColor(142, 170, 219, 255), width: 2);


    result= PdfTextElement(text: cabeceraReporte, font: contentFont).draw(
        page: result.page,
        bounds:
            Rect.fromLTWH(posicionCenter, result.bounds.bottom , 0, 0))!;


    //Dibuja una linea
/*
    result.page.graphics.drawLine(linePen, Offset(0, result.bounds.bottom + 10),
        Offset(result.page.getClientSize().width, result.bounds.bottom + 10));*/

    return result;
  }

  static PdfLayoutResult _drawGridTotales(PdfPage page, PdfLayoutResult result,
      List<DataResumenConsulta> dataResumenConsulta) {
    //Draw grid
    final PdfGrid gridTotales = _getGridDetalleTotales(dataResumenConsulta);

    //le digo la separacion a los margenes de la grid
    double inicioFinal = 150;
    double posicionDondeInicia = result.bounds.bottom + 10;

    result = gridTotales.draw(
        page: page,
        bounds: Rect.fromLTWH(inicioFinal, posicionDondeInicia,
            page.getClientSize().width - inicioFinal, 0))!;

    page = result.page;
    //Draw grand total.

    return result;
  }

  //Draws the grid
  static PdfLayoutResult _drawGrid(PdfPage page, PdfLayoutResult result,
      List<DataResumenConsulta> dataResumenConsulta) {
    //Draw grid
    final PdfGrid grid = _getGridDetalle(dataResumenConsulta);

    //Draw the PDF grid and get the result.

    //le digo la separacion a los margenes de la grid
    double inicioFinal = 5;
    double posicionDondeInicia = result.bounds.bottom + 10;

    result = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(inicioFinal, posicionDondeInicia,
            page.getClientSize().width - inicioFinal, 0))!;

    page = result.page;
    page = result.page;
    //Draw grand total.

    //Dibuja la linea al final

    return result;
  }

  //Create PDF grid and return
  static PdfGrid _getGridDetalle(List<DataResumenConsulta> detalle) {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 4);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'N°';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;

    headerRow.cells[1].value = 'Tipo';
    headerRow.cells[2].value = 'Descripción';
    headerRow.cells[3].value = 'Evento';

    for (int i = 0; i < detalle.length; i++) {
      DataResumenConsulta data = detalle[i];

      _addRows(num: i + 1, data: data, grid: grid);
    }

    //  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5); //aplica un estilo al excel

    //Estable el ancho de cada columna
    grid.columns[0].width = 25;
    grid.columns[1].width = 80;
    grid.columns[3].width = 120;

    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];

      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];

        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  static PdfGrid _getGridDetalleTotales(List<DataResumenConsulta> detalle) {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 4);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;

    headerRow.cells[0].value = 'DETALLE';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;

    headerRow.cells[1].value = 'SIN NOVEDAD';
    headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;

    headerRow.cells[2].value = 'CON NOVEDAD';
    headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;

    headerRow.cells[3].value = 'TOTAL';

    //Estable el ancho de cada columna
    grid.columns[1].width = 55;
    grid.columns[2].width = 55;
    grid.columns[3].width = 40;

    int personasNovedades = 0,
        personas = 0,
        vehiculos = 0,
        vehiculosNovedades = 0;

    //Obtenemos totales
    for (int i = 0; i < detalle.length; i++) {
      DataResumenConsulta data = detalle[i];
      if (data.tipo == 'PERSONA') {
        if (data.detBusqueda == 'TIENE ORDEN DE CAPTURA') {
          personasNovedades++;
        } else {
          personas++;
        }
      } else if (data.tipo == 'VEHÍCULO') {
        if (data.detBusqueda == 'ROBADO') {
          vehiculosNovedades++;
        } else {
          vehiculos++;
        }
      }
    }

    _addTotalesGrid(
        num: 1,
        descripcion: "PERSONAS",
        grid: grid,
        total1: personas,
        total2: personasNovedades,
        total3: personas + personasNovedades);
    _addTotalesGrid(
        num: 2,
        descripcion: "VEHÍCULOS",
        grid: grid,
        total1: vehiculos,
        total2: vehiculosNovedades,
        total3: vehiculos + vehiculosNovedades);

    _addTotalesGrid(
        num: 0,
        descripcion: "TOTAL DE CONSULTAS",
        grid: grid,
        total1: personas + vehiculos,
        total2: personasNovedades + vehiculosNovedades,
        total3: detalle.length);

    //  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5); //aplica un estilo al excel

    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];

      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];

        //Aqui se centran las celdas

        cell.stringFormat.alignment = PdfTextAlignment.center;

        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }

    return grid;
  }

  static get getColorNovedad => PdfSolidBrush(PdfColor(255, 148, 148));

  //Create and row for the grid.
  static void _addRows(
      {required int num,
      required DataResumenConsulta data,
      required PdfGrid grid}) {
    final PdfGridRow row = grid.rows.add();
    String tipo = row.cells[0].value = num.toString();
    row.cells[1].value = data.descOcupante.length > 1
        ? data.tipo + ' (${data.descOcupante})'
        : data.tipo;
    row.cells[2].value = data.descEventoResum.toString();
    row.cells[3].value = data.detBusqueda.toString();

    if (data.detBusqueda == 'TIENE ORDEN DE CAPTURA') {
      row.style = PdfGridCellStyle(
          format: PdfStringFormat(alignment: PdfTextAlignment.center),
//          textPen:PdfPen(PdfColor(0, 0, 0,155)) ,
          borders: PdfBorders.defaultBorder,
          backgroundBrush: getColorNovedad);
    } else if (data.detBusqueda == 'ROBADO') {
      row.style = PdfGridCellStyle(
          borders: PdfBorders.defaultBorder, backgroundBrush: getColorNovedad);
    }
  }

  static void _addTotalesGrid(
      {required int num,
      required String descripcion,
      required int total1,
      required int total2,
      required int total3,
      required PdfGrid grid}) {
    final PdfGridRow row = grid.rows.add();

    // row.cells[0].value = num > 0 ? num.toString() : '';
    row.cells[0].value = descripcion;

    row.cells[1].value = total1.toString();
    row.cells[2].value = total2.toString();
    row.cells[3].value = total3.toString();
  }

  //Get the total amount.
  static double _getPagosAmount(PdfGrid grid) {
    double total = 0;
    return total;

    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
          grid.rows[i].cells[grid.columns.count - 2].value as String;
      total += double.parse(value);
    }
    return total;
  }

  static Future<List<int>> _readImageData(String name) async {
    final ByteData data = await rootBundle.load(name);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}

class ModelResumenConsulta {
  final String tipo;
  final String descripcion;
  final String evento;

  ModelResumenConsulta({
    required this.tipo,
    required this.descripcion,
    required this.evento,
  });
}
